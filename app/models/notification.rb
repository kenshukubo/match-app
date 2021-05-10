class Notification < ApplicationRecord
  belongs_to :target_user, class_name: 'User', foreign_key: 'target_user_id', optional: true

  validates :message, presence: true
  validates :kind, presence: true
  validates :notification_type, presence: true
  validate :duplicate_notification

  enum kind: { usually: 0, admin: 1 }
  enum notification_type: { invite: 0, change: 1, update: 2 }

  def duplicate_notification
    errors.add(:message, "が重複しています") if target_user_id.nil? && Notification.find_by(message: message).present?
  end
end
