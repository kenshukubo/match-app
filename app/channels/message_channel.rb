class MessageChannel < ApplicationCable::Channel
  def subscribed
    p "===MessageChannel subscribed===="
    p "notification_channel_#{params['room_id']}" if params['room_id'].present?
    stream_from "message_channel_#{params['room_id']}" if params['room_id'].present?
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    room = Room.find_by(identified_char: data['identified_char'])
    room_user = RoomUser.find_by(room: room, user: current_user)

    # if room.first_used_at.nil?  
    #   room.assign_attributes(first_used_at: Time.current, first_used_user_id: current_user.id)
    # end
    
    room.assign_attributes(last_used_at: Time.current)
    room.save
    room_user.update(last_active_at: Time.current)
    RoomMessage.create! message: data['text'], message_type: data['message_type'], user_id: current_user.id, room_id: room.id
  end
end
