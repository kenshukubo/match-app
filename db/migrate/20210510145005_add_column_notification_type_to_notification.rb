class AddColumnNotificationTypeToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :notification_type, :integer
  end
end
