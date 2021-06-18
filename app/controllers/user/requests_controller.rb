class User::RequestsController < ApplicationController
  def edit
    request = Request.find(params[:id])

    if request.post.user != current_user
      redirect_to root_path
      flash[:alert] = "閲覧権限がありません"
    end

    @attack_group = request.attack_group
    @request_id   = request.id
    @attackers    = @attack_group.attackers.is_participant
  end

  def update
    request   = Request.find(params[:id])
    attackers = request.attack_group.attackers
    post      = request.post
    begin
      ActiveRecord::Base.transaction do
        request.update!(is_confirmed: true)
        
        # 通知作成
        category = "match"
        message = "マッチしました！"

        attackers.each do |attacker|
          Notification.create!(
            target_user_id: attacker.user_id,
            message: message,
            category: category,
            url: post_path(post.id)
          )

          UserNotification.find_by(user_id: attacker.user_id).add_unchecked_notification_count
        end
        flash[:notice] = "アタックを承認しました"
        redirect_to root_path
      end
    rescue => error
      p error
      flash[:alert] = "アタックの承認に失敗しました"
      redirect_to edit_request_path(request.id)
    end
  end
end
