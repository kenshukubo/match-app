class AddColumnTypeToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :type, :integer
  end
end
