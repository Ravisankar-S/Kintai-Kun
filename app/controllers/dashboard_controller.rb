class DashboardController < ApplicationController
  def index
    @active_log = current_user.work_logs.active.first

    @today_logs = current_user.work_logs.for_date(Date.today).completed
    @today_minutes = @today_logs.sum(:duration_minutes)

    @week_logs = current_user.work_logs.for_week(Date.today).completed
    @week_minutes = @week_logs.sum(:duration_minutes)

    if @active_log
      active_minutes =
        ((Time.current - @active_log.clocked_in_at) / 60).to_i

      if @active_log.clocked_in_at.to_date == Date.current
        @today_minutes += active_minutes
      end

      if @active_log.clocked_in_at.to_date.between?(Date.current.beginning_of_week(:monday),
                                                    Date.current.end_of_week(:monday))
        @week_minutes += active_minutes
      end
    end

    @zangyo_level = compute_zangyo_level
    @weekly_summary = compute_weekly_summary
    @heatmap_data = compute_heatmap_data
  end

  private

  def compute_weekly_summary
    worked_days = @week_logs.map { |log| log.clocked_in_at.to_date }.uniq
    overtime_days = @week_logs.select { |log| log.duration_minutes > 480 }.map { |log| log.clocked_in_at.to_date }.uniq

    avg_minutes = if worked_days.count.positive?
      (@week_minutes.to_f / worked_days.count).round
    else
      0
    end

    {
      days_worked: worked_days.count,
      total_minutes: @week_minutes,
      avg_minutes: avg_minutes,
      overtime_days: overtime_days.count
    }
  end

  def compute_heatmap_data
    start_date = 83.days.ago.to_date.beginning_of_week(:monday)

    logs = current_user.work_logs.completed.where(
      clocked_in_at: start_date.beginning_of_day..Time.current
    )

    logs.group_by { |log| log.clocked_in_at.to_date }.transform_values do |day_logs|
      day_logs.sum(&:duration_minutes)
    end
  end

  def compute_zangyo_level
    overtime_days_this_week = @week_logs.select { |log| log.duration_minutes > 480 }
                                        .map { |log| log.clocked_in_at.to_date }
                                        .uniq
                                        .count

    return 2 if overtime_days_this_week >= 3
    return 1 if @today_minutes > 480
    0
  end
end