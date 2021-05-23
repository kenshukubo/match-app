class AddColumnIsListedToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :is_listed, :boolean, default: false
  end
end
