class Api::V1::PostListedChecksController < Api::ApplicationController
  def update
    return if Post.find_by(user: current_user).blank? || !current_user 
    render json: { isModal: Post.find_by(user: current_user).is_modal }
  end
end