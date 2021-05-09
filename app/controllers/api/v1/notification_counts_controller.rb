class Api::V1::NotificationCountsController < Api::ApplicationController
  def show
    @notification_count = UserNotification.find_by(user: current_user).unchecked_num
  end
end