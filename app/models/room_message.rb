class RoomMessage < ApplicationRecord
  belongs_to :user
  belongs_to :room

  enum message_type: { text: 0, emoji: 1}

  after_create_commit { RoomMessageBroadcastJob.perform self }
end
