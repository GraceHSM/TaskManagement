class CreateSortLists < ActiveRecord::Migration[5.2]
  def change
    create_table :sort_lists do |t|
      t.integer :task_id
      t.integer :sort

      t.timestamps
    end
  end
end
