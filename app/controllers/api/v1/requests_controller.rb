class Api::V1::RequestsController < Api::ApplicationController
  def create
    attack_group = AttackGroup.find_by(user: current_user, group_number: params[:group_number])
    selected_post = Post.find(params[:selected_post_id])

    begin
      ActiveRecord::Base.transaction do
        Request.create!(
          attack_group: attack_group,
          post: selected_post
        )

        post_member_ids = selected_post.post_members.pluck(:user_id)

        # 通知作成
        category = "request"
        message = "募集にアタックされました"

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
    end
  end
end