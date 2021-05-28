class Api::V1::AddAttackersController < Api::ApplicationController
  def index
    attacker_user_ids = Attacker
    .where(attack_group_id: params[:attack_group_id])
    .pluck(:user_id)

    @friends = current_user.friend_users.same_sex(current_user).where.not(id: attacker_user_ids)
  end

  def create
    
  end
end