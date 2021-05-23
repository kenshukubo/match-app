class Api::V1::PostsController < Api::ApplicationController
  def index

    return if !current_user

    @posts = Post
    .includes(:post_members, :user)
    .where.not(users: {sex: current_user.sex})
    .where(is_listed: true)
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy!
  end
end