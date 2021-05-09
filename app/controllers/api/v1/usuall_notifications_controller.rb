class Api::V1::UsuallNotificationsController < Api::ApplicationController
  def index
    current_user_id = current_user.id

    @notification_count = UserNotification.find_by(user: current_user).unchecked_num

    @usuall_notifications = Notification
    .where(target_user_id: current_user_id, kind:"usually")
    .order(created_at: :desc)
    .limit(20)
  end
end