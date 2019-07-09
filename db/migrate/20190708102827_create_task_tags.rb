class CreateTaskTags < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tags do |t|
      t.integer :tasks_id
      t.integer :tags_id

      t.timestamps
    end
  end
end
