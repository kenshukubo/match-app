class AttackGroup < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_many :attackers, dependent: :destroy
end
