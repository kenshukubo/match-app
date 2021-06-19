class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :identified_char
      t.timestamps
    end
  end
end
