class Api::V1::PostsController < Api::ApplicationController
  def index

    return if !current_user

    #TODO 開始日時が切れたやつを除く
    @posts = Post
    .includes(:post_members, :user)
    .where.not(users: {sex: current_user.sex})
    .all_member_join

    @attack_group_ids = current_user.attack_groups.pluck(:id)
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy!
  end
end