class RemoveColumnSexFromUserProfile < ActiveRecord::Migration[6.1]
  def change
    remove_column :user_profiles, :sex, :integer
  end
end
