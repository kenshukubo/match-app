class Api::V1::AttackGroupsController < Api::ApplicationController
  def index
    @attack_groups = AttackGroup.includes(:attackers).where(user: current_user)
  end
end