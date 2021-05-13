class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user_id, presence: true
  validates :friend_id, presence: true #followなど他のカラムが増えた場合、検討必要
end
