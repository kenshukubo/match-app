class Api::V1::CurrentUsersController < Api::ApplicationController
  protect_from_forgery with: :null_session

  def show
    @current_user = current_user
  end

end
