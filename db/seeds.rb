# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

if User.exists?
  puts "Data already exists. Skipping seed to prevent duplication on Render deploy."
else
  puts "No users found. Beginning initial database seed..."

  puts "Creating Admin..."
  admin = User.create!(
    email: "admin@kintai.com",
    name: "Admin User",
    password: "password",
    password_confirmation: "password",
    role: "admin",
    work_mode: "flex",
    preferred_locale: "en"
  )

  puts "Creating Employees..."
  employee1 = User.create!(
    email: "employee1@kintai.com",
    name: "Taro Yamada",
    password: "password",
    password_confirmation: "password",
    role: "employee",
    work_mode: "fixed",
    fixed_start_time: Time.parse("09:00"),
    fixed_end_time: Time.parse("18:00"),
    preferred_locale: "ja"
  )

  employee2 = User.create!(
    email: "employee2@kintai.com",
    name: "Jane Smith",
    password: "password",
    password_confirmation: "password",
    role: "employee",
    work_mode: "flex",
    preferred_locale: "en"
  )

  puts "Generating Work Logs (including overtime)..."
  users = [admin, employee1, employee2]

  users.each do |user|
    # Generate 14 days of data
    (1..14).to_a.reverse.each do |days_ago|
      date = days_ago.days.ago.to_date
      next if date.saturday? || date.sunday? # Skip weekends

      # Random clock-in between 8:45 AM and 9:15 AM
      start_time = date.to_time.change(hour: 8, min: 45) + rand(0..30).minutes
      
      # 30% chance for an overtime day (>8 hours)
      is_overtime_day = rand < 0.3
      
      if is_overtime_day
        # 9.5 to 11.5 hours duration (570 to 690 mins)
        duration_minutes = rand(570..690)
        memo = ["Worked late on the new project release", "Late client meeting", "Extra push for milestone", "残業 (Overtime)"].sample
      else
        # 7.5 to 8.5 hours duration (450 to 510 mins)
        duration_minutes = rand(450..510)
        memo = ["Regular shift", "Morning sync & coding", "Standard work day", nil].sample
      end

      end_time = start_time + duration_minutes.minutes
      is_overtime = duration_minutes > 480

      WorkLog.create!(
        user: user,
        clocked_in_at: start_time,
        clocked_out_at: end_time,
        duration_minutes: duration_minutes,
        is_overtime: is_overtime,
        memo: memo,
        created_at: end_time, 
        updated_at: end_time
      )
    end
  end

  puts "Seeded successfully."
  puts "Login Credentials:"
  puts "------------------"
  puts "Admin: admin@kintai.com / password"
  puts "Emp 1: employee1@kintai.com / password"
  puts "Emp 2: employee2@kintai.com / password"
end
