class User::UserProfilesController < ApplicationController
  def show
  end

  def edit
    @user_profile = current_user.user_profile
  end

  def update
    @user_profile = current_user.user_profile
    if @user_profile.update(
      name: user_profile_params[:name],
      sex: user_profile_params[:sex],
      age: user_profile_params[:age],
      job: user_profile_params[:job],
    )
      flash[:success] = "更新が完了しました。"
      redirect_to edit_user_profile_path
    else
      flash[:danger] = "更新に失敗しました。"
      edit_user_profile_path
    end
  end

  private
    def user_profile_params
      params.require(:user_profile).permit(:name, :sex, :age, :job, :image, :introduction)
    end
end