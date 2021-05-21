json.zoomInProfile do
  json.image @user_profile.image.thumb.url
  json.name  @user_profile.name
  json.age   @user_profile.age
  json.job   @user_profile.job
end