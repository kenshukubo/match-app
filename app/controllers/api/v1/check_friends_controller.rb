class Api::V1::CheckFriendsController < Api::ApplicationController
  def index
    @any_friends = current_user.friend_users.same_sex(current_user).present?

    post = current_user.post
    @not_invited_friends = current_user.friend_users
    .same_sex(current_user)
    .includes(:post_members)
    .where.not(id: PostMember.where(post: post).pluck(:user_id))
  end
end