class AddColumnGroupNumberToAttackGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :attack_groups, :group_number, :integer
  end
end
