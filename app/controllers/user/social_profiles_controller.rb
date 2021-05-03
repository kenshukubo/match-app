class User::SocialProfilesController < User::ApplicationController
  before_action :require_other_login_info, only: [:destroy]

  def destroy
    @social_profile = SocialProfile.find(params[:id])
    provider_name = @social_profile.provider
    @social_profile.destroy!

    flash[:notice] = "#{provider_name}の連携を解除しました。"
    # redirect_to edit_user_user_accounts_path 未定
  end

  private
    def require_other_login_info
      if current_user.social_profiles.count <= 1
        flash[:alert] = "連携しているSNSが１つしかない、又は認証済みのemailがないので、連携を解除できません。"
        redirect_to root_path
        return
      end
    end
end
