class User::PostMembersController < ApplicationController

  def new
    unless current_user.post.present?
      redirect_to root_path 
      flash[:alert] = "募集を作成しましょう"
    end
  end
end
