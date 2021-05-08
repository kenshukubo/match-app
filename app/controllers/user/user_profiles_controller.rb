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
      image: user_profile_params[:image],
    )
      if @user_profile.has_valid_profile?
        flash[:notice] = "🥳プロフィール更新完了！"
      else
        flash[:notice] = "🤮プロフィール情報が不足しています"
      end
      redirect_to root_path
    else
      flash[:alert] = "更新に失敗しました"
      edit_user_profile_path
    end
  end

  private
    def user_profile_params
      params.require(:user_profile).permit(:name, :sex, :age, :job, :image, :introduction)
    end
end