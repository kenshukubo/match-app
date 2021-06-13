class Api::V1::AttackGroupChecksController < Api::ApplicationController
  def show
    @any_attack_groups = current_user.attack_groups.where(all_member_ready: true).present?
    render json: { anyAttackGroups: @any_attack_groups }
  end
end