class User::RequestsController < ApplicationController
  def edit
    @attack_group = AttackGroup.includes(:attackers).find(params[:id])
    request = Request.find_by(attack_group: @attack_group, post: current_user.post)

    if request.blank?
      redirect_to root_path
      flash[:alert] = "閲覧権限がありません"
    end

    @attackers = @attack_group.attackers
  end

  def update
  end
end
