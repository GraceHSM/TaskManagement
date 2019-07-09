class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :content
      t.datetime :start_at
      t.datetime :deadline_at
      t.integer :priority
      t.string :status
      t.string :integer
      t.integer :user_id

      t.timestamps
    end
  end
end
