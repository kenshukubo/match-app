json.roomMessages do
  json.array!(@room_messages) do |room_message|
    json.userProfileImageUrl room_message.user.user_profile.image.icon.url
    json.text                room_message.message
  end
end