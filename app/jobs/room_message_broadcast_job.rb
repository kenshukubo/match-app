class RoomMessageBroadcastJob < ApplicationJob
  queue_as :default

  def self.perform(room_message)
    ActionCable.server.broadcast "message_channel_#{room_message.room.identified_char}", messageId: room_message.id, roomIdentifiedChar: room_message.room.identified_char,userIdentifiedChar: room_message.user.user_profile.identified_char, userProfileName: room_message.user.user_profile.name, userProfileImageUrl: room_message.user.user_profile.image.icon.url, text: room_message.message, messageType: room_message.message_type, createdAt: room_message.created_at, formattedCreatedAt: room_message.created_at.strftime("%m/%d %H:%M")
  end
end
