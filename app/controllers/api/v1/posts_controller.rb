class Api::V1::PostsController < Api::ApplicationController
  def index
    @posts = Post.all.includes(:post_members)
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy!
  end
end