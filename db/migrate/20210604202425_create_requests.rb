class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.references :attack_group, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.boolean :is_confirmed, default: false
      t.timestamps
    end
  end
end
