class CreateUserProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :image
      t.integer :age
      t.integer :job
      t.text :introduction
      t.string :identified_char
      t.boolean :is_email_receivable, default: true
      t.boolean :is_line_receivable, default: true
      t.timestamps
    end
  end
end
