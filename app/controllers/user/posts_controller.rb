class User::PostsController < ApplicationController
  before_action :inviting_member, only: [:new, :edit]
  def new

    if current_user.post.present?
      @post = current_user.post
      @invitable_number = @post.number - PostMember.where(post: @post).count
    else
      @new_post = Post.new
    end

    @join_member = PostMember
    .includes(:user)
    .where(post: current_user.post, status: "attend")
  end

  def show
    if Post.find_by_id(params[:id]).blank?
      redirect_to root_path
      return
    end
    
    @post = Post.find(params[:id])
    post_text = "#{@post.place}で#{@post.time.strftime("%-m月%-d日 %H:%M")}から一緒にご飯いきませんか？"
    @post_url = "https://res.cloudinary.com/dvtpktk39/image/upload/l_text:Sawarabi%20Gothic_64:#{@post_text},co_rgb:000,w_1000,y_-100,c_fit/v1624887961/loubjdivz8e7awbfezgj.png"
    @post_members = @post.post_members
  end

  def create
    @post = current_user.build_post(post_params)
    if @post.save

      #自分のレコード作成
      PostMember.create!(
        user: current_user,
        post: @post,
        is_confirmed: true,
        status: "attend"
      )

      redirect_to new_post_member_path, notice: 'メンバーを選びましょう'
    else
      redirect_to new_post_path, alert: '作成に失敗しました'
    end
  end

  def edit
    @post = current_user.post
  end

  def update
    @post = current_user.post
    begin
      ActiveRecord::Base.transaction do
        @post.update!(post_params)

        # 既に招待されている人数より小さい値の場合
        raise if PostMember.where(post: @post).count > post_params[:number].to_i

        user_ids = PostMember.where(post: @post).where.not(user: current_user).pluck(:user_id)
        message = "#{current_user.user_profile.name}さんの募集が削除されました。"
        category = "change"

        user_ids.each do |user_id|
          Notification.create!(
            target_user_id: user_id,
            message: message,
            category: category,
            url: post_path(@post.id)
          )
          user_notification = UserNotification.find_by(user_id: user_id)
          user_notification.add_unchecked_notification_count
        end
      end
      flash[:notice] = "更新完了！"
      redirect_to new_post_path
    rescue => error
      p error
      flash[:alert] = "更新に失敗しました"
      redirect_to edit_post_path(@post.id)
    end
  end

  def destroy
    @post = current_user.post
    begin
      ActiveRecord::Base.transaction do
        @post.destroy
        user_ids = PostMember.where(post: @post).where.not(user: current_user).pluck(:user_id)
        message = "募集内容が変更されました。チェックしましょう。"
        category = "change"

        user_ids.each do |user_id|
          Notification.create!(
            target_user_id: user_id,
            message: message,
            category: category
          )
          user_notification = UserNotification.find_by(user_id: user_id)
          user_notification.add_unchecked_notification_count
        end

        PostMember.where(post: @post).destroy_all
      end
      redirect_to new_post_path, notice: '募集を削除しました'
    rescue => error
      p error
      redirect_to new_post_path, alert: '削除に失敗しました'
    end
  end

  private
    def post_params
      params.require(:post).permit(:user_id, :place, :number, :time)
    end

    def inviting_member
      @invited_user_exclude_me = PostMember
      .includes(user: [:user_profile])
      .where(post: current_user.post)
      .where.not(user: current_user) #自分以外

      @unconfirmed_members = @invited_user_exclude_me.where(is_confirmed: false)
      @attend_members      = @invited_user_exclude_me.where(status: "attend")
      @absent_members      = @invited_user_exclude_me.where(status: "absent")
    end
end