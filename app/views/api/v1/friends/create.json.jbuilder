json.addedUser do
  json.id           @added_user.id
  json.name         @added_user.user_profile.name
  json.image        @added_user.user_profile.image.url
  json.isFriend     true
end 