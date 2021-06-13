class User::PostMembersController < ApplicationController

  def new
    #募集を作成していない場合飛ばす
    unless current_user.post.present?
      redirect_to root_path 
      flash[:alert] = "募集を作成しましょう"
    end

    if current_user.sex == "male"
      @sex = "男子"
    else
      @sex = "女子"
    end

    post = current_user.post
    @invitable_number = post.number - PostMember.where(post: post).count

    @invited_user_exclude_me = PostMember
    .includes(user: [:user_profile])
    .where(post: post)
    .where.not(user: current_user)

    @unconfirmed_members = @invited_user_exclude_me.where(is_confirmed: false)
    @attend_members      = @invited_user_exclude_me.where(status: "attend")
    @absent_members      = @invited_user_exclude_me.where(status: "absent")
  end

  def create
    @post = current_user.post
    begin
      ActiveRecord::Base.transaction do

        invitable_number = @post.number - PostMember.where(post: @post).count

        # 人数オーバーであればリターン
        raise if select_member_params[:user_id].count > invitable_number

        # 通知作成用
        category = "invite"
        message = "#{current_user.user_profile.name}さんに募集メンバーに招待されました"

        select_member_params[:user_id].each do |user_id|

          # PostMember作成
          current_user.invite_member(user_id, @post)
          post_member = PostMember.find_by(user_id: user_id)

          # 通知作成
          Notification.create!(
            target_user_id: user_id,
            message: message,
            category: category,
            url: edit_post_member_path(post_member.id)
          )

          UserNotification.find_by(user_id: user_id).add_unchecked_notification_count
        end
      end
      redirect_to new_post_member_path
      flash[:notice] = "招待完了しました"
    rescue => error
      p error
      redirect_to new_post_member_path
      flash[:alert] = "招待に失敗しました"
    end
  end

  def edit
    @post_member = PostMember.find(params[:id])
    @post = @post_member.post
  end

  def update
    post_member = PostMember.find(params[:id])
    post = post_member.post
    begin
      ActiveRecord::Base.transaction do
        post_member.update(
          status: post_member_params[:status],
          is_confirmed: true
        )

        host_user_id = post.user_id
        username = current_user.user_profile.name

        if post_member_params[:status] == "attend"
          category = "attend"
          message = "#{username}さんが参加しました"
        else #absent
          category = "absent"
          message = "#{username}さんは残念ながら参加できません"
        end

        Notification.create!(
          target_user_id: host_user_id,
          message: message,
          category: category,
          url: post_path(post.id)
        )

        UserNotification.find_by(user_id: host_user_id).add_unchecked_notification_count
      end
      flash[:notice] = "更新完了！"
      redirect_to root_path
    rescue => error
      p error
      flash[:alert] = "更新に失敗しました"
      redirect_to edit_post_member_path(post_member.id)
    end
  end

  def destroy
    @invited_member = PostMember.find(params[:id])
    invited_member_user_id = @invited_member.user_id
    begin
      ActiveRecord::Base.transaction do
        @invited_member.destroy

        message = "招待がキャンセルされました"
        category = "change"

        Notification.create!(
          target_user_id: invited_member_user_id,
          message: message,
          category: category
        )

        user_notification = UserNotification.find_by(user_id: invited_member_user_id)
        user_notification.add_unchecked_notification_count
      end
      redirect_to new_post_member_path, notice: '招待をキャンセルしました'
    rescue => error
      p error
      redirect_to new_post_member_path, alert: '招待キャンセルに失敗しました'
    end
  end

  private
    def post_member_params
      params.require(:post_member).permit(:status)
    end

    def select_member_params
      params.require(:post_member).permit({:user_id => []})
    end
end
