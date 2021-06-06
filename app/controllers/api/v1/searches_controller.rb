class Api::V1::SearchesController < Api::ApplicationController
  def index
    @keyword = params[:keyword]
    @users = User
    .includes(:user_profile)
    .where.not(id: current_user.id)
    .same_sex(current_user)
    .search_by_keyword(@keyword)
  end
end