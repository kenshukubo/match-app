class User < ApplicationRecord

  devise :invitable, :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :omniauthable, :confirmable, omniauth_providers: %i[line], invite_for: 24.hours

  has_one  :user_profile, dependent: :destroy
  has_one  :post, dependent: :destroy
  has_many :notifications, foreign_key: 'target_user_id', dependent: :destroy
  has_one  :user_notification, dependent: :destroy
  has_many :post_members, dependent: :destroy

  def self.dummy_email(social)
    "#{social.uid}-#{social.provider}@example.com"
  end

  def invite?
    PostMember.find_by(post: self.post).present?
  end
end
