class AddColumnStatusToPostMember < ActiveRecord::Migration[6.1]
  def change
    add_column :post_members, :status, :integer
  end
end
