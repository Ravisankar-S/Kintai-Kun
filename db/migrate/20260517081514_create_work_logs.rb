class CreateWorkLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :work_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clocked_in_at
      t.datetime :clocked_out_at
      t.string :memo, limit: 140
      t.integer :duration_minutes
      t.boolean :is_overtime,
                default: false,
                null: false

      t.timestamps
    end

    add_index :work_logs,
              :user_id,
              unique: true,
              where: "clocked_out_at IS NULL",
              name: "index_one_active_work_log_per_user"
  end
end