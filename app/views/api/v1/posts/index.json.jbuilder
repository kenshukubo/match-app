json.postList do
  json.array!(@posts) do |post|
    json.id             post.id
    json.place          post.place
    json.time           post.time.strftime("%-m月%-d日 %H:%M")
    json.number         post.number
    json.sex            post.user.sex
    json.createdAt      post.created_at.strftime("%-m月%-d日 %H時%M分")
    json.isHost         post.user == current_user
    json.isAttacked     Request.find_by(post: post, attack_group: @attack_group_ids).present?
    json.members do
      json.array! UserProfile.where(user_id: post.post_members.pluck(:user_id)) do |user_profile|
        json.id user_profile.id
        json.image user_profile.image.icon.url
      end
    end
  end
end