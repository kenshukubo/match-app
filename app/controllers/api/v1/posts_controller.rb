class Api::V1::PostsController < Api::ApplicationController
  def index
    @posts = Post.all
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy!
  end
end