class Api::V1::AddPostMembersController < Api::ApplicationController
  def create
    post = current_user.post
    user_ids = params[:user_ids]
    begin
      ActiveRecord::Base.transaction do
        invitable_number = post.number - PostMember.where(post: post).count

        # 人数オーバーであればリターン
        raise if user_ids.count > invitable_number

        # 通知作成用
        category = "invite"
        message = "#{current_user.user_profile.name}さんから募集メンバーに招待されました"

        user_ids.each do |user_id|

          # PostMember作成
          current_user.invite_member(user_id, post)
          post_member = PostMember.find_by(user_id: user_id)

          # 通知作成
          Notification.create!(
            target_user_id: user_id,
            message: message,
            category: category,
            url: edit_post_member_path(post_member.id)
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