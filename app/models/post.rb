class Post < ApplicationRecord
  belongs_to :user

  has_many :post_members, dependent: :destroy

  validates :number, presence: true
  validates :place, presence: true
  validates :time, presence: true
end
