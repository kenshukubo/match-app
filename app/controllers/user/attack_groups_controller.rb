class User::AttackGroupsController < ApplicationController
  def index
    @attack_groups = AttackGroup
    .includes(:attackers)
    .where(user: current_user)
    .order(group_number: :asc)
  end

  def new
    @attackers = Attacker.new
    @hosts_friends = current_user.friend_users.same_sex(current_user)
    @attack_groups_number = current_user.attack_groups.count
  end

  def destroy
    group = AttackGroup.find(params[:id])
    if group.destroy

      AttackGroup.all.each.with_index(1) do |attack_group, index|
        attack_group.update!(group_number: index)
      end

      redirect_to attack_groups_path, notice: 'チームを削除しました'
    else
      redirect_to attack_groups_path, notice: 'チームの削除に失敗しました'
    end
  end

  private

  def select_member_params
    params.require(:attacker).permit({:user_id => []})
  end
end
