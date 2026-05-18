class PunchesController < ApplicationController
  def clock_in
    if current_user.work_logs.active.exists?
      redirect_to dashboard_path,
                  alert: "You are already clocked in."
      return
    end

    current_user.work_logs.create!(
      clocked_in_at: Time.current,
      memo: params[:memo]
    )

    redirect_to dashboard_path,
                notice: "Clocked in successfully."
  end

  def clock_out
    active_log = current_user.work_logs.active.first

    unless active_log
      redirect_to dashboard_path,
                  alert: "No active work session found."
      return
    end

    active_log.update!(
      clocked_out_at: Time.current,
      duration_minutes: (
        (Time.current - active_log.clocked_in_at) / 60
      ).to_i,
      is_overtime: (
        (Time.current - active_log.clocked_in_at) / 60
      ) > 480,
      memo: params[:memo]
    )

    redirect_to dashboard_path,
                notice: "Clocked out successfully."
  end
end