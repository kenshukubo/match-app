class CreateAttackers < ActiveRecord::Migration[6.1]
  def change
    create_table :attackers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :attack_group, null: false, foreign_key: true
      t.boolean :is_confirmed, default: false
      t.integer :status
      t.timestamps
    end
  end
end
