require 'open-uri'

class SocialUserCreator
  attr_accessor :user
  attr_reader :auth

  def initialize(auth)
    @auth = auth
    @user = User.new
  end

  def execute!
    build_user
    user.save!(validate: false)
  end

  private

  def build_user
    set_auth_info_to_user_profile
    add_social_profiles
  end

  def set_auth_info_to_user_profile
    unless user.persisted?
      require 'open-uri'
      file = open(URI.parse(auth['info']['image']))
      
      user.build_user_profile(
        name: auth.info.name,
        remote_image_url: auth.info.image,
        identified_char: SecureRandom.uuid
      )
      user.build_user_notification
      user.email = User.dummy_email(auth)
      user.skip_confirmation!
    end
  end

  def add_social_profiles
    user.social_profiles << SocialProfile.initialize_with_omniauth(auth)
  end

  def user_exists?(auth)
    auth.info.email && User.exists?(email: auth.info.email) ? true : false
  end
end
