class Api::V1::FriendsController < Api::ApplicationController
  def create
    other_user = User.find(params[:user_id])
    current_user.make_friend(other_user)
  end
end