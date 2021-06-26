class User::PostMembersController < ApplicationController

  def new
    #募集を作成していない場合飛ばす
    unless current_user.post.present?
      redirect_to new_post_path
      flash[:alert] = "募集を作成しましょう"
      return
    end

    @post = current_user.post
    @invitable_number = @post.number - PostMember.where(post: @post).count

    @invited_user_exclude_me = PostMember
    .includes(user: [:user_profile])
    .where(post: @post)
    .where.not(user: current_user)

    @unconfirmed_members = @invited_user_exclude_me.where(is_confirmed: false)
    @attend_members      = @invited_user_exclude_me.where(status: "attend")
    @absent_members      = @invited_user_exclude_me.where(status: "absent")
  end

  def edit
    if PostMember.find_by_id(params[:id]).blank?
      redirect_to root_path
      flash[:alert] = "通知の期限が切れています"
      return
    end

    @post_member = PostMember.find(params[:id])
    @post = @post_member.post

    @host_user = @post.user
    @invited_user_exclude_me = PostMember
    .includes(user: [:user_profile])
    .where(post: @post)
    
    @unconfirmed_members = @invited_user_exclude_me.where(is_confirmed: false)
    @attend_members      = @invited_user_exclude_me.where(status: "attend")
    @absent_members      = @invited_user_exclude_me.where(status: "absent")
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
          message = "#{username}さんが参加表明しました"
        else #absent
          category = "absent"
          message = "#{username}さんは残念ながら参加できません"
        end
        
        # メンバー揃ったら募集公開
        post.update!( is_modal: true ) if post.all_member_here?

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
    begin
      ActiveRecord::Base.transaction do
        @invited_member = PostMember.find(params[:id])
        invited_member_user_id = @invited_member.user_id

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
