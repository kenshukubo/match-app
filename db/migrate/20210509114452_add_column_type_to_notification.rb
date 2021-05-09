class AddColumnTypeToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :kind, :integer, default: 0
  end
end
