class StaticPagesController < ApplicationController

  def home
    if current_user
      unless current_user.user_profile.has_valid_profile?
        redirect_to edit_user_profile_path
      end
    end

  end
end