json.roomMessages do
  json.array!(@room_messages) do |room_message|
    json.messageId           room_message.id
    json.userIdentifiedChar  room_message.user.user_profile.identified_char
    json.userProfileImageUrl room_message.user.user_profile.image.icon.url
    json.text                room_message.message
    json.formattedCreatedAt  room_message.created_at.strftime("%m/%d %H:%M")
  end
end