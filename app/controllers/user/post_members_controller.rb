class User::PostMembersController < ApplicationController

  def new
    #募集を作成していない場合飛ばす
    unless current_user.post.present?
      redirect_to root_path 
      flash[:alert] = "募集を作成しましょう"
    end

    @invited_user = User.filter_by_invited
    @unconfirmed_members = @invited_user.where(post_members: {is_confirmed: false})
    @attend_members      = @invited_user.where(post_members: {status: "attend"})
    @absent_members      = @invited_user.where(post_members: {status: "absent"})

    @post_members = PostMember.new
    @not_invited_friends = current_user.friend_users.filter_by_not_invited
  end

  def create
    @post = current_user.post
    begin
      ActiveRecord::Base.transaction do
        select_member_params[:user_id].each do |user_id|

          # PostMember作成
          current_user.invite_member(user_id, @post)

          # 通知作成
          category = "invite"
          message = "#{current_user.user_profile.name}さんに招待されました"
          post_member = PostMember.find_by(user_id: user_id)

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
    @post_member = PostMember.find(params[:id])
    @post = @post_member.post
    begin
      ActiveRecord::Base.transaction do
        @post_member.update(
          status: post_member_params[:status],
          is_confirmed: true
        )

        host_user_id = @post.user_id
        username = current_user.user_profile.name

        if post_member_params[:status] == "attend"
          category = "attend"
          message = "#{username}さんは参加を希望しました"
        else #absent
          category = "absent"
          message = "#{username}さんは残念ながら参加できません"
        end

        Notification.create!(
          target_user_id: host_user_id,
          message: message,
          category: category,
          url: post_path(@post.id)
        )

        user_notification = UserNotification.find_by(user_id: host_user_id)
        user_notification.add_unchecked_notification_count
      end
      flash[:notice] = "更新完了！"
      redirect_to root_path
    rescue => error
      p error
      flash[:alert] = "更新に失敗しました"
      redirect_to edit_post_member_path(@post_member.id)
    end
  end

  def destroy
    @invited_member = PostMember.find(params[:id])
    if @invited_member.destroy
      redirect_to new_post_member_path, notice: '招待をキャンセルしました'
    else
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
