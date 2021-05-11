class PostMember < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum status: { attend: 0, absent: 1 }
end
