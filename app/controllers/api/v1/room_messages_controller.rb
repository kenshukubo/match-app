class Api::V1::RoomMessagesController < Api::ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_room, only:[:index]

  def index
    # total_countだけ返して、vue側で処理も検討
    all_room_messages = @room.room_messages.includes(user: :user_profile)

    @room_messages = all_room_messages.limit(20).order(created_at: :desc)
  end

  private

    def set_room
      @room = current_user.rooms.find_by(identified_char: params[:room_identified_char])
    end
end
