class Request < ApplicationRecord
  belongs_to :attack_group
  belongs_to :post
end
