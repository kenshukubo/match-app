class AddColumnAllMemberReadyToAttackGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :attack_groups, :all_member_ready, :boolean, defaulf: false
  end
end
