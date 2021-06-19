json.rooms do
  json.array!(@rooms) do |room|
    json.lastUsedAt       room.last_used_at
    json.roomUsers do
      json.array!(room.room_users) do |room_user|
        json.identifiedChar room_user.user.user_profile.identified_char
        json.name           room_user.user.user_profile.name
        json.image          room_user.user.user_profile.image.icon.url
      end
    end
  end
end