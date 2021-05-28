class Attacker < ApplicationRecord
  belongs_to :user
  belongs_to :attack_group

  enum status: { attend: 0, absent: 1 }

  scope :is_participant, ->() do
    where(status: "attend")
  end
end
