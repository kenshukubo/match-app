class User::AttackersController < ApplicationController
  def edit
    @attacker = Attacker.find(params[:id])
  end

  def update
    attacker = Attacker.find(params[:id])
    attack_group = attacker.attack_group
    begin
      ActiveRecord::Base.transaction do
        attacker.update(
          status: attacker_params[:status],
          is_confirmed: true
        )

        host_user_id = attack_group.user_id
        username = current_user.user_profile.name

        if attacker_params[:status] == "attend"
          category = "attend"
          message = "#{username}さんが参加しました"
        else #absent
          category = "absent"
          message = "#{username}さんは残念ながら参加できません"
        end

        Notification.create!(
          target_user_id: host_user_id,
          message: message,
          category: category,
          url: attack_groups_path
        )

        UserNotification.find_by(user_id: host_user_id).add_unchecked_notification_count
      end
      flash[:notice] = "更新完了！"
      redirect_to root_path
    rescue => error
      p error
      flash[:alert] = "更新に失敗しました"
      redirect_to edit_attacker_path(attacker.id)
    end
  end

  def destroy
    @invited_member = Attacker.find(params[:id])
    invited_member_user_id = @invited_member.user_id
    begin
      ActiveRecord::Base.transaction do
        @invited_member.destroy

        message = "招待がキャンセルされました"
        category = "change"

        Notification.create!(
          target_user_id: invited_member_user_id,
          message: message,
          category: category
        )

        user_notification = UserNotification.find_by(user_id: invited_member_user_id)
        user_notification.add_unchecked_notification_count
      end
      redirect_to attack_groups_path, notice: '招待をキャンセルしました'
    rescue => error
      p error
      redirect_to attack_groups_path, alert: '招待キャンセルに失敗しました'
    end
  end

  private
    def attacker_params
      params.require(:attacker).permit(:status)
    end
end