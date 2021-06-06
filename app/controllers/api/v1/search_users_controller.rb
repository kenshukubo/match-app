class Api::V1::SearchUsersController < Api::ApplicationController
  def index
    @keyword = params[:keyword]
    @searched_users = User
    .includes(:user_profile, :relationships)
    .where.not(id: current_user.id)
    .where.not(id: current_user.friend_users.pluck(:id))
    .same_sex(current_user)
    .search_by_keyword(@keyword)
  end
end