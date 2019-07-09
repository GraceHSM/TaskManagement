class RenameColumnFromTags < ActiveRecord::Migration[5.2]
  def change
    rename_column :tags, :users_id, :user_id
  end
end
