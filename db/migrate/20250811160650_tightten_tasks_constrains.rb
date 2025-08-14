class TighttenTasksConstrains < ActiveRecord::Migration[7.1]
  def change
    change_column_default :tasks, :status, 0
    change_column_null :tasks, :status, false
    change_column_null :tasks, :name, false

    add_index :tasks, :status
    add_index :tasks, :due_date
    add_index :tasks, [:project_id, :status]
  end
end
