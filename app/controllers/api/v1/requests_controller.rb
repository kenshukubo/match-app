class Api::V1::RequestsController < Api::ApplicationController
  def index
    @attack_groups = AttackGroup.includes(:attackers).where(user: current_user)
  end
  
  def create
    user_attack_group_ids = current_user.attack_groups.pluck(:id)
    attack_group = AttackGroup.find_by(user: current_user, group_number: params[:group_number])
    selected_post = Post.find(params[:selected_post_id])

    begin
      ActiveRecord::Base.transaction do
        raise if Request.find_by(attack_group_id: user_attack_group_ids, post: selected_post).present?

        Request.create!(
          attack_group: attack_group,
          post: selected_post
        )

        post_member_ids = selected_post.post_members.pluck(:user_id)

        # 通知作成
        category = "request"
        message = "あなたの募集にアタックされました"

        post_member_ids.each do |user_id|
          Notification.create!(
            target_user_id: user_id,
            message: message,
            category: category,
            url: attack_group_path(attack_group.id)
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