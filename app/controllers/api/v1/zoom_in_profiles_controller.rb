class Api::V1::ZoomInProfilesController < Api::ApplicationController
  def show
    @user_profile = UserProfile.find(params[:id])
  end
end