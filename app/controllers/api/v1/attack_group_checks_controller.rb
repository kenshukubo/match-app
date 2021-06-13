class Api::V1::AttackGroupChecksController < Api::ApplicationController
  def show
    @any_attack_groups = current_user.attack_groups.present?
    @any_requests      = Request.where(post_id: params[:post_id], attack_group: current_user.attack_groups).present?

    render json: { anyAttackGroups: @any_attack_groups, anyRequest: @any_requests }
  end
end