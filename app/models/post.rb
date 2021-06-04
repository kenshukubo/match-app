class Post < ApplicationRecord
  belongs_to :user

  has_many :post_members, dependent: :destroy
  has_many :requests, dependent: :destroy

  validates :number, presence: true
  validates :place, presence: true
  validates :time, presence: true

  scope :all_member_join, ->() do
    where('number = ?', PostMember.where(post: self, status: "attend").count)
  end

  def all_member_here?
    PostMember.where(post: self, status: "attend").count == self.number
  end
end
