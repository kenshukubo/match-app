class User::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = current_user.build_post(post_params)
    if @post.save
      redirect_to new_post_path, notice: 'メンバーを選びましょう'
    else
      redirect_to new_post_path, alert: '作成に失敗しました'
    end
  end

  private
    def post_params
      params.require(:post).permit(:user_id, :place, :number, :time, :detail)
    end
end