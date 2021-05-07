class User::UserProfilesController < ApplicationController
  def show
  end

  def edit
    @user_profile = current_user.user_profile
  end

  def update
    @user_profile = current_user.user_profile
  end
end