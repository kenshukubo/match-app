json.anyFriends @any_friends

json.listedFriends do
  json.array!(@not_invited_friends) do |friend|
    json.id    friend.id
    json.name  friend.user_profile.name
    json.image friend.user_profile.image.icon.url
  end
end