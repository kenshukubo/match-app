class User < ApplicationRecord

  devise :invitable, :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :omniauthable, :confirmable, omniauth_providers: %i[line], invite_for: 24.hours

  has_one  :user_profile, dependent: :destroy
  has_one  :post, dependent: :destroy
  has_many :notifications, foreign_key: 'target_user_id', dependent: :destroy
  has_one  :user_notification, dependent: :destroy
  has_many :post_members, dependent: :destroy
  has_many :attack_groups, dependent: :destroy
  has_many :attackers, dependent: :destroy

  has_many :relationships
  has_many :friend_users, through: :relationships, source: :friend
  has_many :reverse_friend_relationships, class_name: 'UserRelationship', foreign_key: 'friend_id'
  has_many :is_friend_users, through: :reverse_friend_relationships, source: :user

  validates :sex, presence: true

  enum sex: { male: 0, female: 1 }

  scope :search_by_keyword, ->(keyword) do
    joins(:user_profile)
    .merge(UserProfile.search_by_keyword keyword)
  end

  def create_data_for_signup
    UserProfile.create!(user: self, name: "ゲスト", identified_char: SecureRandom.uuid)
    UserNotification.create!(user: self)
  end

  def self.dummy_email(social)
    "#{social.uid}-#{social.provider}@example.com"
  end

  ################ 招待系 ################
  def invite_member(invited_user_id, post)
    if post.user.sex == User.find(invited_user_id).sex
      PostMember.create!(user_id: invited_user_id, post: post)
    end
  end

  def invite_any?
    PostMember.find_by(post: self.post).present?
  end

  def all_member_invite?(post)
    PostMember.where(post: post).count == post.number
  end

  ################ 友達系 ################
  def make_friend(other_user)
    return if self == other_user
    self.relationships.find_or_create_by(friend_id: other_user.id)
  end

  def remove_friend(other_user)
    relationships = self.relationships.find_by(friend_id: other_user.id)
    return unless relationships
    relationships.destroy
  end

  def is_friend?(other_user)
    self.friend_users.include?(other_user)
  end
end
