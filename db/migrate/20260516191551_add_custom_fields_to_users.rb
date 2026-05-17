class AddCustomFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :role, :string, null: false, default: 'employee'
    add_column :users, :work_mode, :string, null: false, default: 'fixed'
    add_column :users, :fixed_start_time, :time
    add_column :users, :fixed_end_time, :time
    add_column :users, :preferred_locale, :string, null: false, default: 'en'

    add_index :users, :role
  end
end