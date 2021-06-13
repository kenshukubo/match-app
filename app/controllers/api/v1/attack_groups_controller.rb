class Api::V1::AttackGroupsController < Api::ApplicationController
  def create
    user_ids = params[:user_ids]
    begin
      ActiveRecord::Base.transaction do
        if current_user.attack_groups.present?
          group_number = current_user.attack_groups.last.group_number + 1
        else
          group_number = 1
        end

        attack_group = AttackGroup.create!(
          user: current_user,
          group_number: group_number
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

        user_ids.each do |user_id|
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
    rescue => error
      p error
      status 400
    end
  end
end