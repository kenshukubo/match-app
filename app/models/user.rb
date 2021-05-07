class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :omniauthable, :confirmable, omniauth_providers: %i[line]

  has_one  :user_profile, dependent: :destroy

  def self.dummy_email(social)
    "#{social.uid}-#{social.provider}@example.com"
  end

end
