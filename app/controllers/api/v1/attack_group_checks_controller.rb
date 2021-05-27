class Api::V1::AttackGroupChecksController < Api::ApplicationController
  def show
    @any_attack_groups = current_user.attack_groups.present?
    render json: { anyAttackGroups: @any_attack_groups }
  end
end