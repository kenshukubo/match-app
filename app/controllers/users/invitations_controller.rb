class Users::InvitationsController < Devise::InvitationsController
  def new
    super
  end

  def create
    super
    if @user.save
      invite_user = User.find(@user.invited_by_id)
      PostMember.create(
        user: @user,
        post: invite_user.post
      )
    end
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end

  private
    def after_invite_path_for(resource)
      new_post_member_path
    end
end