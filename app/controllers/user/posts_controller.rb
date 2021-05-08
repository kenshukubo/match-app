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

  def edit
    @post = current_user.post
  end

  def update
    @post = current_user.post
    if @post.update!(
      place: post_params[:place],
      number: post_params[:number],
      time: post_params[:time],
      detail: post_params[:detail],
    )
      flash[:notice] = "更新完了！"
      redirect_to root_path
    else
      flash[:alert] = "更新に失敗しました"
      redirect_to edit_post_path(@post.id)
    end
  end

  def destroy
    @post = current_user.post
    if @post.destroy
      redirect_to root_path, notice: '募集を削除しました'
    else
      redirect_to new_post_path, alert: '削除に失敗しました'
    end
  end

  private
    def post_params
      params.require(:post).permit(:user_id, :place, :number, :time, :detail)
    end
end