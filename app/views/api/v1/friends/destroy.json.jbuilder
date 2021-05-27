json.removedUser do
  json.id           @removed_user.id
  json.name         @removed_user.user_profile.name
  json.image        @removed_user.user_profile.image.url
  json.isFriend     false
end 