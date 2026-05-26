namespace :demo do
  desc "Refresh work logs for demo purposes"
  task refresh: :environment do
    target_emails = ["admin@kintai.com", "employee1@kintai.com", "employee2@kintai.com"]
    processed_count = 0

    target_emails.each do |email|
      employee = User.find_by(email: email)
      unless employee
        puts "Warning: Employee #{email} not found. Skipping."
        next
      end

      employee.work_logs.destroy_all

      available_dates = (0..59).map { |i| i.days.ago.to_date }.reject { |d| d.saturday? || d.sunday? }
      forced_dates = available_dates.take(3)
      remaining_dates = available_dates.drop(3)

      memos = ['', '', '', 'Client meeting', '社内MTG', 'Code review', 'リリース対応', 'Deployment day', 'Sprint planning', '週次レビュー']

      forced_dates.each do |date|
        start_time = date.to_time.change(hour: 9) + rand(0..30).minutes
        duration = 540
        end_time = start_time + duration.minutes
        lat = 35.491487760130155
        lng = 133.27205427931727

        employee.work_logs.create!(
          clocked_in_at: start_time,
          clocked_out_at: end_time,
          clock_in_latitude: lat,
          clock_in_longitude: lng,
          clock_out_latitude: lat,
          clock_out_longitude: lng,
          duration_minutes: duration,
          is_overtime: true,
          memo: memos.sample.presence,
          created_at: end_time,
          updated_at: end_time
        )
      end

      remaining_dates.each do |date|
        start_time = date.to_time.change(hour: 9) + rand(0..30).minutes
        hours = [7, 7.5, 8, 8, 8.5, 9, 9.5, 10].sample
        duration = (hours * 60).to_i
        is_overtime = duration > 480
        end_time = start_time + duration.minutes
        lat = 35.491487760130155
        lng = 133.27205427931727

        employee.work_logs.create!(
          clocked_in_at: start_time,
          clocked_out_at: end_time,
          clock_in_latitude: lat,
          clock_in_longitude: lng,
          clock_out_latitude: lat,
          clock_out_longitude: lng,
          duration_minutes: duration,
          is_overtime: is_overtime,
          memo: memos.sample.presence,
          created_at: end_time,
          updated_at: end_time
        )
      end

      processed_count += 1
    end

    puts "Demo data refreshed for #{processed_count} employees. All logs relative to #{Date.today}."
  end
end
