class User::RoomsController < User::ApplicationController
  before_action :set_layout, only: [:show]

  def show
    @user = current_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_layout
      render :layout => 'chat'
    end
end
