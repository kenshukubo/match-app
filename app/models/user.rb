class User < ApplicationRecord

  devise :invitable, :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :omniauthable, :confirmable, omniauth_providers: %i[line], invite_for: 24.hours

  has_one  :user_profile, dependent: :destroy
  has_one  :post, dependent: :destroy
  has_many :notifications, foreign_key: 'target_user_id', dependent: :destroy
  has_one  :user_notification, dependent: :destroy
  has_many :post_members, dependent: :destroy

  scope :filter_by_invited, ->() do
    includes(:post_members)
    .where.not(post_members: {id: nil})
  end

  def self.dummy_email(social)
    "#{social.uid}-#{social.provider}@example.com"
  end

  def invite_any?
    PostMember.find_by(post: self.post).present?
  end

  def all_member_invite?
    PostMember.where(post: self.post).count == Post.find_by(user: self).number
  end
end
