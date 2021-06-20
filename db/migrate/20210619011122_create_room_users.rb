class CreateRoomUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :room_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.datetime :last_active_at

      t.timestamps
    end
  end
end
