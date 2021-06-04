class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.references :attack_group, null: false, foreign_key: true
      t.references :posts, null: false, foreign_key: true
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
