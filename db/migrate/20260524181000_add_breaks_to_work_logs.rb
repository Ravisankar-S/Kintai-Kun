class AddBreaksToWorkLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :work_logs, :break_minutes, :integer, default: 0, null: false
    add_column :work_logs, :break_started_at, :datetime
  end
end
