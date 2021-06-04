class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.references :attack_group, null: false, foreign_key: true
      t.references :posts, null: false, foreign_key: true
      t.integer :status
      t.timestamps
    end
  end
end
