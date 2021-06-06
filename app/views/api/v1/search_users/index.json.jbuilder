json.searchedUsers do
  json.array!(@searched_users) do |user|
    json.id    user.id
    json.name  user.user_profile.name
    json.image user.user_profile.image.icon.url
  end
end