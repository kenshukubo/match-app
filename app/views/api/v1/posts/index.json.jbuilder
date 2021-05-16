json.postList do
  json.array!(@posts) do |post|
    json.place      post.place
    json.time       post.time
    json.number     post.number
    json.detail     post.detail
    json.createdAt  post.created_at.strftime("%-m月%-d日 %-H時%-M分")
    json.isHost     post.user == current_user
  end
end