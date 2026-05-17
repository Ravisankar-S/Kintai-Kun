# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_17_081514) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.time "fixed_end_time"
    t.time "fixed_start_time"
    t.string "name", null: false
    t.string "preferred_locale", default: "en", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "employee", null: false
    t.datetime "updated_at", null: false
    t.string "work_mode", default: "fixed", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "work_logs", force: :cascade do |t|
    t.datetime "clocked_in_at"
    t.datetime "clocked_out_at"
    t.datetime "created_at", null: false
    t.integer "duration_minutes"
    t.boolean "is_overtime", default: false, null: false
    t.string "memo", limit: 140
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_one_active_work_log_per_user", unique: true, where: "(clocked_out_at IS NULL)"
    t.index ["user_id"], name: "index_work_logs_on_user_id"
  end

  add_foreign_key "work_logs", "users"
end
