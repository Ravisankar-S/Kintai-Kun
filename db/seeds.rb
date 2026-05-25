# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Cleaning up existing data..."
WorkLog.destroy_all
User.destroy_all

puts "Creating Admin..."
admin = User.find_or_create_by!(email: "admin@kintai.com") do |u|
  u.name = "Admin User"
  u.password = "password"
  u.password_confirmation = "password"
  u.role = "admin"
  u.work_mode = "flex"
  u.preferred_locale = "en"
end

puts "Creating Employees..."
employee1 = User.find_or_create_by!(email: "employee1@kintai.com") do |u|
  u.name = "Taro Yamada"
  u.password = "password"
  u.password_confirmation = "password"
  u.role = "employee"
  u.work_mode = "fixed"
  u.fixed_start_time = Time.parse("09:00")
  u.fixed_end_time = Time.parse("18:00")
  u.preferred_locale = "ja"
end

employee2 = User.find_or_create_by!(email: "employee2@kintai.com") do |u|
  u.name = "Jane Smith"
  u.password = "password"
  u.password_confirmation = "password"
  u.role = "employee"
  u.work_mode = "flex"
  u.preferred_locale = "en"
end

puts "Seed complete!"
puts "Login Credentials:"
puts "------------------"
puts "Admin: admin@kintai.com / password"
puts "Emp 1: employee1@kintai.com / password"
puts "Emp 2: employee2@kintai.com / password"
