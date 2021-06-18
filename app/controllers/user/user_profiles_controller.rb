class User::UserProfilesController < ApplicationController
  def edit
    @user_profile = current_user.user_profile
  end

  def update
    @user_profile = current_user.user_profile

    begin
      ActiveRecord::Base.transaction do
        @user_profile.update(
          name: user_profile_params[:name],
          age: user_profile_params[:age],
          job: user_profile_params[:job],
          image: user_profile_params[:image],
        )

        raise unless @user_profile.has_valid_profile?
      end
      flash[:notice] = "🥳プロフィール更新完了！"
      redirect_to root_path
    rescue => error
      p error
      flash[:notice] = "🤮プロフィール情報が不足しています"
      redirect_to edit_user_profile_path
    end
  end

  private
    def user_profile_params
      params.require(:user_profile).permit(:name, :age, :job, :image, :introduction)
    end
end