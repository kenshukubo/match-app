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

  def create
    begin
      ActiveRecord::Base.transaction do

        if current_user.attack_groups.present?
          group_number = current_user.attack_groups.last.group_number + 1
        else
          group_number = 1
        end

        attack_group = AttackGroup.create!(
          user: current_user,
          group_number: group_number,
        ) if AttackGroup.find_by(group_number: group_number).blank?

        # 自分用に作成
        Attacker.create!(
          user: current_user,
          attack_group: attack_group,
          is_confirmed: true,
          status: "attend"
        ) if attack_group.present?

        # 通知作成用
        category = "invite"
        message = "#{current_user.user_profile.name}さんからアタックチームに招待されました"

        # その他メンバーを作成
        select_member_params[:user_id].each do |user_id|
          attacker = Attacker.create!(
            user_id: user_id,
            attack_group: attack_group,
          ) if attack_group.present?

          # 通知作成
          Notification.create!(
            target_user_id: user_id,
            message: message,
            category: category,
            url: edit_attacker_path(attacker.id)
          )

          UserNotification.find_by(user_id: user_id).add_unchecked_notification_count
        end
      end
      redirect_to attack_groups_path
      flash[:notice] = "招待完了しました"
    rescue => error
      p error
      redirect_to new_attack_group_path
      flash[:alert] = "招待に失敗しました"
    end
  end

  def destroy
    group = AttackGroup.find(params[:id])
    if group.destroy
      Attacker.where(attack_group: group).destroy_all
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
