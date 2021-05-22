class StaticPagesController < ApplicationController

  def home
    if current_user
      unless current_user.user_profile.has_valid_profile?
        redirect_to edit_user_profile_path
      end
      @user_profile = current_user.user_profile
      @invited_number = PostMember.where.not(post: current_user.post).where(user: current_user).count
    end
  end
end