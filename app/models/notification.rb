class Notification < ApplicationRecord
  belongs_to :target_user, class_name: 'User', foreign_key: 'target_user_id', optional: true

  validates :message, presence: true
  validate :duplicate_notification

  def duplicate_notification
    errors.add(:message, "が重複しています") if target_user_id.nil? && Notification.find_by(message: message).present?
  end
end
