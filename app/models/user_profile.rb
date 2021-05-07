class UserProfile < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: {maximum: 20}
  validates :introduction, length: {maximum: 400}
  validates :identified_char, presence: true, uniqueness: true

  mount_uploader :image, ProfileImageUploader

  enum sex: { male: 0, female: 1 }
  enum job: { student: 0, banker: 1, nurse: 2 }

  def has_valid_profile?
    self.name.present? && self.image.present? && self.sex.present? && self.age.present? && self.job.present?
  end
end
