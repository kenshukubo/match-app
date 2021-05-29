# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  def line
    callback_from(:line)
  end

  private
    def callback_from(provider)
      auth   = request.env['omniauth.auth']
      social = SocialProfile.send("find_with_#{provider}", auth)
      user_signed_in? ? connect_existing_account_with_omniauth(auth, provider) : sign_in_social_and_create_user(auth, provider)
    end

    def connect_existing_account_with_omniauth(auth, provider)
      if social_profile = SocialProfile.find_by(uid: auth.uid, provider: provider)
        flash[:alert] = "この#{provider.upcase}アカウントは、既に他のユーザーのアカウントと連携されています。"
        # redirect_to edit_user_account_path 未定
        return
      end
      current_user.social_profiles << SocialProfile.initialize_with_omniauth(auth)
      current_user.save!(validate: false)
      flash[:notice] = "アカウントの連携に成功しました"
  
      # redirect_to edit_user_account_path 未定
    end
  
    def sign_in_social_and_create_user(auth, provider)
      if social_profile = SocialProfile.find_by(uid: auth.uid, provider: provider)
        social_profile.update!(access_token: auth.credentials.token, refresh_token: auth.credentials.refresh_token)
        user = social_profile.user
      else
        creator = SocialUserCreator.new(auth)
        creator.execute!
        user = creator.user
      end
      sign_in_and_redirect user, event: :authentication
    end
end
