class Attacker < ApplicationRecord
  belongs_to :user
  belongs_to :attack_group

  enum status: { attend: 0, absent: 1 }
end
