json.users do
  json.array!(@users) do |user|
    json.id     user.id
    json.name   user.user_profile.name
    json.image  user.user_profile.image.url
  end
end