class CreateRoomMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :room_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.text :message
      t.integer :message_type
      t.string :emoji

      t.timestamps
    end
  end
end
