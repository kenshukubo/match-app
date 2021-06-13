class Api::V1::AddAttackersController < Api::ApplicationController
  def index
    attacker_user_ids = Attacker
    .where(attack_group_id: params[:attack_group_id])
    .pluck(:user_id)

    @friends = current_user.friend_users.same_sex(current_user).where.not(id: attacker_user_ids)
  end

  def create
    user_id = params[:user_id]
    begin
      ActiveRecord::Base.transaction do
        attacker = Attacker.create!(
          user_id: user_id,
          attack_group_id: params[:group_id],
        )

        # 通知作成用
        category = "invite"
        message = "#{current_user.user_profile.name}さんにアタックチームに招待されました"

        # 通知作成
        Notification.create!(
          target_user_id: user_id,
          message: message,
          category: category,
          url: edit_attacker_path(attacker.id)
        )
        UserNotification.find_by(user_id: user_id).add_unchecked_notification_count
      end
    rescue => error
      p error
      status 400 
    end
  end
end