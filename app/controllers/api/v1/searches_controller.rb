class Api::V1::SearchesController < Api::ApplicationController
  def show
    @keyword = params[:keyword]
    @users = User
    .includes(:user_profile)
    .where.not(id: current_user.id)
    .search_by_keyword(@keyword)
  end
end