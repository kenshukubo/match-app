class UserNotification < ApplicationRecord
  belongs_to :user

  validates :unchecked_num, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def add_unchecked_notification_count
    self.unchecked_num += 1
    self.save!
  end
end
