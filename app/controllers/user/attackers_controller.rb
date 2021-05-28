class User::AttackersController < ApplicationController
  def edit
  end

  def update
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
end