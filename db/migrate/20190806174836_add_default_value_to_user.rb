class AddDefaultValueToUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :tasks_count, :integer, default: 0
  end
end
