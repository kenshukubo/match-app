class Api::V1::PostsController < Api::ApplicationController
  def index
    @posts = Post
    .includes(:post_members, :user)
    .where.not(users: {sex: current_user.sex})
    .all_member_join
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy!
  end
end