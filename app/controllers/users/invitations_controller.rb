class Users::InvitationsController < Devise::InvitationsController
  before_action :configure_permitted_parameters

  def new
    super
  end

  def create
    super
    return unless @user.id.present?

    begin
      ActiveRecord::Base.transaction do
        @user.create_data_for_signup
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

    begin
      ActiveRecord::Base.transaction do
        invite_user = User.find(@user.invited_by_id)

        # お互いにフレンド追加
        invite_user.make_friend(@user)
        @user.make_friend(invite_user)

        # 通知作成
        message = "#{invite_user.user_profile.name}さんに招待されました"
        category = "invite"

        Notification.create!(
          target_user_id: @user.id,
          message: message,
          category: category
        )

        UserNotification.find_by(user: @user).add_unchecked_notification_count
      end
    rescue => error
      p error
      flash[:alert] = "ユーザー情報の編集に失敗しました"
      return
    end
    
  end

  def destroy
    super
  end

  private
    def after_invite_path_for(resource)
      new_post_member_path
    end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:accept_invitation, keys: [:sex])
    end
end