class CreateUserNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :user_notifications do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :unchecked_num, null: false, default: 0
      t.datetime :message_last_emailed_at
      t.datetime :message_last_lined_at
      t.timestamps
    end
  end
end
