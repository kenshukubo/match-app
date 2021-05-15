class Users::InvitationsController < Devise::InvitationsController
  def new
    super
  end

  def create
    super
    return unless @user.id.present?

    begin
      ActiveRecord::Base.transaction do

        @user.create_data_for_signup

        invite_user = User.find(@user.invited_by_id)
        post_member = PostMember.create(user: @user, post: invite_user.post)

        message = "#{invite_user.user_profile.name}さんに招待されました"
        category = "invite"

        Notification.create!(
          target_user_id: @user.id,
          message: message,
          category: category,
          url: edit_post_member_path(post_member.id)
        )

        UserNotification.find_by(user: @user).add_unchecked_notification_count
      end
    rescue => error
      p error
      flash[:alert] = "ユーザーの作成に失敗しました"
      redirect_to new_post_member_path and return
      return
    end  
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end

  private
    def after_invite_path_for(resource)
      new_post_member_path
    end
end