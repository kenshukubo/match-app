class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :target_user_id
      t.text :message
      t.string :image
      t.string :url
      t.boolean :checked, default: false, null: false
      t.index ["target_user_id"], name: "index_notifications_on_target_user_id"
      t.timestamps
    end
  end
end
