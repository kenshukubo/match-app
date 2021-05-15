class Api::V1::PostsController < Api::ApplicationController
  def index
    @posts = Post.all
  end
end