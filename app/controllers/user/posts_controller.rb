class User::PostsController < ApplicationController
  def new

    if current_user.post.present?
      @post = current_user.post
    else
      @post = Post.new
    end

    @invited_user_include_me = PostMember
    .includes(:user)
    .where(post: current_user.post)

    @invited_user_exclude_me = PostMember
    .includes(:user)
    .where(post: current_user.post)
    .where.not(user: current_user) #自分以外

    @unconfirmed_members = @invited_user_exclude_me.where(is_confirmed: false)
    @attend_members      = @invited_user_exclude_me.where(status: "attend")
    @absent_members      = @invited_user_exclude_me.where(status: "absent")
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
        @post.update!(
          place: post_params[:place],
          number: post_params[:number],
          
          detail: post_params[:detail],
        )

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
      redirect_to root_path
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
      end
      redirect_to root_path, notice: '募集を削除しました'
    rescue => error
      p error
      redirect_to new_post_path, alert: '削除に失敗しました'
    end
  end

  private
    def post_params
      params.require(:post).permit(:user_id, :place, :number, :time, :detail)
    end
end