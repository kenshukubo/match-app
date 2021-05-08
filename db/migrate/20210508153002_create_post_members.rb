class CreatePostMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :post_members do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.boolean :is_confirmed, default: false
      t.timestamps
    end
  end
end
