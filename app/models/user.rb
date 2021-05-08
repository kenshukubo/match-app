class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :omniauthable, :confirmable, omniauth_providers: %i[line]

  has_one  :user_profile, dependent: :destroy
  has_one  :post, dependent: :destroy
  has_many :notifications, foreign_key: 'target_user_id', dependent: :destroy
  has_one  :user_notification, dependent: :destroy

  def self.dummy_email(social)
    "#{social.uid}-#{social.provider}@example.com"
  end

end
