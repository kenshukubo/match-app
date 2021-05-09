class Api::V1::UsuallNotificationsController < Api::ApplicationController
  def index
    current_user_id = current_user.id

    @usuall_notifications = Notification
    .where(target_user_id: current_user_id, kind:"usually")
    .order(created_at: :desc)
    .limit(20)

    current_user.user_notification.update(unchecked_num: 0)
  end
end