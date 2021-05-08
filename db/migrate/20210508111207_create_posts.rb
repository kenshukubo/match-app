class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :detail
      t.integer :number
      t.string :place
      t.datetime :time
      t.timestamps 
    end
  end
end
