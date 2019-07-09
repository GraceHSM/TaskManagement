class RenameColumnFromTaskTags < ActiveRecord::Migration[5.2]
  def change
    rename_column :task_tags, :tasks_id, :task_id
    rename_column :task_tags, :tags_id, :tag_id
  end
end
