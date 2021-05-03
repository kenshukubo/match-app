class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :confirmable, omniauth_providers: %i[line]

  def self.dummy_email(social)
    "#{social.uid}-#{social.provider}@example.com"
  end
end
