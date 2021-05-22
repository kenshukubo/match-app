class Attacker < ApplicationRecord
  belongs_to :user
  belongs_to :attack_group
end
