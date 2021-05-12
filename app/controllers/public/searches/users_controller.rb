class Public::Searches::UsersController < ApplicationController
  before_action :set_keyword, only: [:index]

  def index
    @users = User.search_by_keyword(@keyword)
  end

  private
  def set_keyword
      @keyword = params[:keyword]
  end
end
