class AttackGroup < ApplicationRecord
  belongs_to :user
  belongs_to :post, optional: true

  has_many :attackers, dependent: :destroy

  validates :group_number, presence: true, uniqueness: {scope: :user_id}, numericality: {only_integer: true, greater_than: 0}
end
