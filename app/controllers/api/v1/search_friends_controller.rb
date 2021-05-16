class Api::V1::SearchFriendsController < Api::ApplicationController
  def index
    @keyword = params[:keyword]
    @friends = current_user.friend_users
    .includes(:user_profile)
    .where.not(id: current_user.id)
    .search_by_keyword(@keyword)
  end
end