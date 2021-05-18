class AddColumnSexToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :sex, :integer, null: false
  end
end
