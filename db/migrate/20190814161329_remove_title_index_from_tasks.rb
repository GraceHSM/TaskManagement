class RemoveTitleIndexFromTasks < ActiveRecord::Migration[5.2]
  def change
    remove_index :tasks, :title
  end
end
