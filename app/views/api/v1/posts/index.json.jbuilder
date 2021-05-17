json.postList do
  json.array!(@posts) do |post|
    json.id         post.id
    json.place      post.place
    json.time       post.time.strftime("%-m月%-d日 %H:%M")
    json.number     post.number
    json.detail     post.detail
    json.createdAt  post.created_at.strftime("%-m月%-d日 %H時%M分")
    json.isHost     post.user == current_user
    json.members do
      json.array! User.find(post.post_members.pluck(:user_id)) do |user|
        if user.user_profile.image.present?
          json.image user.user_profile.image.icon.url
        else
          json.image user.user_profile.image.url
        end
      end
    end
  end
end