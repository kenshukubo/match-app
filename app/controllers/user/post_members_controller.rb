class User::PostMembersController < ApplicationController

  def new
    #募集を作成していない場合飛ばす
    unless current_user.post.present?
      redirect_to root_path 
      flash[:alert] = "募集を作成しましょう"
    end

    @invited_members = User.includes(:post_members).where.not(post_members: {id: nil})
  end

  def destroy
    @invited_member = PostMember.find(params[:id])
    if @invited_member.destroy
      redirect_to new_post_member_path, notice: '招待をキャンセルしました'
    else
      redirect_to new_post_member_path, alert: '招待キャンセルに失敗しました'
    end
  end
end
