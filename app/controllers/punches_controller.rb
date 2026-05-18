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
    active_log.duration_minutes = (
      (active_log.clocked_out_at - active_log.clocked_in_at) / 60
    ).to_i
    active_log.is_overtime = active_log.duration_minutes > 480

    if active_log.save
      redirect_to dashboard_path,
                  notice: t("punches.clocked_out_success")
    else
      redirect_to dashboard_path,
                  alert: t("punches.clock_out_error")
    end
  end
end