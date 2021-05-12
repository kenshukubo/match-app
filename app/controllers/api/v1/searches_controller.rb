class Api::V1::SearchesController < Api::ApplicationController
  def show
    @keyword = params[:keyword]
    @users = User.search_by_keyword(@keyword)
  end
end