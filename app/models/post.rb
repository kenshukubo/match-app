class Post < ApplicationRecord
  belongs_to :user

  has_many :post_members, dependent: :destroy

  validates :number, presence: true
  validates :place, presence: true
  validates :time, presence: true

  scope :all_member_join, ->() do
    where('number = ?', PostMember.where(post: self, status: "attend").count)
  end
end
