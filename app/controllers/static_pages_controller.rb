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

  def update
    begin
      ActiveRecord::Base.transaction do
        current_user.sex = user_profile_params[:sex]
        current_user.save!
      end
      flash[:notice] = "🥳 設定完了しました"
      redirect_to root_path
    rescue => error
      p error
      flash[:alert] = "設定に失敗しました"
      redirect_to root_path
      return
    end  
  end

  private
    def user_profile_params
      params.require(:user).permit(:sex)
    end
end