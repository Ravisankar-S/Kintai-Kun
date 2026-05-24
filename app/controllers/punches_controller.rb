class PunchesController < ApplicationController
  def clock_in
    if current_user.work_logs.active.exists?
      redirect_to dashboard_path,
                  alert: t("punches.already_clocked_in")
      return
    end

    log = current_user.work_logs.build(
      clocked_in_at: Time.current,
      memo: params[:memo].presence
    )

    if log.save
      redirect_to dashboard_path,
                  notice: t("punches.clocked_in_success")
    else
      redirect_to dashboard_path,
                  alert: t("punches.clock_in_error")
    end
  end

  def clock_out
    active_log = current_user.work_logs.active.first

    unless active_log
      redirect_to dashboard_path,
                  alert: t("punches.not_clocked_in")
      return
    end

    active_log.clocked_out_at = Time.current
    active_log.memo = params[:memo].presence || active_log.memo
    
    # Auto-end break if currently on break
    if active_log.on_break?
      break_duration = ((Time.current - active_log.break_started_at) / 60).to_i
      active_log.break_minutes += break_duration
      active_log.break_started_at = nil
    end

    total_duration = ((active_log.clocked_out_at - active_log.clocked_in_at) / 60).to_i
    active_log.duration_minutes = [total_duration - active_log.break_minutes, 0].max
    active_log.is_overtime = active_log.duration_minutes > 480

    if active_log.save
      redirect_to dashboard_path,
                  notice: t("punches.clocked_out_success")
    else
      redirect_to dashboard_path,
                  alert: t("punches.clock_out_error")
    end
  end

  def take_break
    active_log = current_user.work_logs.active.first
    if active_log && !active_log.on_break?
      active_log.update(break_started_at: Time.current)
      redirect_to dashboard_path, notice: t("punches.break_started")
    else
      redirect_to dashboard_path, alert: t("punches.cannot_take_break")
    end
  end

  def resume_work
    active_log = current_user.work_logs.active.first
    if active_log && active_log.on_break?
      break_duration = ((Time.current - active_log.break_started_at) / 60).to_i
      active_log.update(
        break_minutes: active_log.break_minutes + break_duration,
        break_started_at: nil
      )
      redirect_to dashboard_path, notice: t("punches.work_resumed")
    else
      redirect_to dashboard_path, alert: t("punches.cannot_resume_work")
    end
  end
end