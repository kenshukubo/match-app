class Api::V1::RoomsController < Api::ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_room, only:[:show]
  # before_action :set_offset, only:[:index]
  
  def index
    all_rooms_count = current_user.rooms.count
    @rooms = current_user.rooms.order(last_used_at: :desc).limit(20)
  end

  def show
  end

  private
    # def set_offset
    #   @offset = 0
    #   @offset = params[:offset].to_i if params[:offset].present?
    # end

    def set_room
      @room = current_user.rooms.find_by(identified_char: params[:identified_char])
    end
end
