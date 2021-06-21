json.rooms do
  json.array!(@rooms) do |room|
    json.identifiedChar   room.identified_char
    json.lastUsedAt       room.last_used_at
    json.roomUsers do
      json.array!(room.room_users) do |room_user|
        if room_user.last_active_at.present?
          json.unreadMessageCount room.room_messages.where("created_at > ?", room_user.last_active_at).where.not(user_id: room_user.user_id).size
        else  
          json.unreadMessageCount room.room_messages.size
        end
        json.identifiedChar room_user.user.user_profile.identified_char
        json.name           room_user.user.user_profile.name
        json.image          room_user.user.user_profile.image.icon.url
      end
    end
  end
end