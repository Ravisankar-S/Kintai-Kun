class AddLocationToWorkLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :work_logs, :clock_in_latitude, :float
    add_column :work_logs, :clock_in_longitude, :float
    add_column :work_logs, :clock_out_latitude, :float
    add_column :work_logs, :clock_out_longitude, :float
  end
end
