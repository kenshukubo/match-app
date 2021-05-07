class UserProfile < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: {maximum: 20}
  validates :introduction, length: {maximum: 400}
  validates :identified_char, presence: true, uniqueness: true

  mount_uploader :image, ProfileImageUploader

  enum sex: { men: 0, women: 1, other: 2 }
  enum job: { student: 0, banker: 1, nurse: 2 }
end
