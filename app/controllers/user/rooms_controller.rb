class User::RoomsController < ApplicationController

  def show
    @user = current_user
  end
end
