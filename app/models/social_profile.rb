class SocialProfile < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: { scope: [:provider, :uid] }

  class << self

    def initialize_with_omniauth(auth)
      # lineに最適化されている状態
      new(
        uid: auth['uid'], 
        provider: auth['provider'], 
        access_token: auth['credentials']['token'], 
        access_secret: auth['credentials']['secret'],
        refresh_token: auth['credentials']['refresh_token'],
        credentials: auth['credentials'].to_json,
        raw_info: auth['info'].to_json
      )
    end

  end
end
