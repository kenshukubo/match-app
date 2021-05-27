class Api::V1::FriendsController < Api::ApplicationController
  def create
    @added_user = User.find(params[:user_id])
    current_user.make_friend(@added_user)
  end

  def destroy
    @removed_user = User.find(params[:user_id])
    current_user.remove_friend(@removed_user)
  end
end