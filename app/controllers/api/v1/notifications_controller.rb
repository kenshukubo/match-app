class Api::V1::NotificationsController < Api::ApplicationController
  def index
    current_user_id = current_user.id

    @usuall_notifications = Notification
    .where(target_user_id: current_user_id, kind:"usually")
    .order(created_at: :desc)
    .limit(20)

    @admin_notifications = Notification
    .where(target_user_id: current_user_id, kind:"admin")
    .order(created_at: :desc)
    .limit(20)
  end
end