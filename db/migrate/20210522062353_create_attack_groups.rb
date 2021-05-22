class CreateAttackGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :attack_groups do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, foreign_key: true
      t.timestamps
    end
  end
end
