class ChangeStatusFromTasks < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :tasks do |t|
        dir.up   { t.change :status, 'integer USING CAST(status AS integer)' }
        dir.down { t.change :status, :string }
      end
    end
  end
end
