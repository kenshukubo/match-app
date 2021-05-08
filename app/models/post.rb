class Post < ApplicationRecord
  belongs_to :user

  validates :detail, presence: true
  validates :number, presence: true
  validates :place, presence: true
  validates :time, presence: true
end
