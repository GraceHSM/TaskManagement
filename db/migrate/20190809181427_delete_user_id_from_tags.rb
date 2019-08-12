class DeleteUserIdFromTags < ActiveRecord::Migration[5.2]
  def change
    remove_column :tags, :user_id, :integer
  end
end
