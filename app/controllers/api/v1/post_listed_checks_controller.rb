class Api::V1::PostListedChecksController < Api::ApplicationController
  def update
    @post = Post.find_by(user: current_user)

    if @post.is_modal
      render json: { isModal: false }
    else
      @post.update!(is_modal: true) if @post.all_member_here?
      render json: { isModal: @post.is_modal }
    end
  end
end