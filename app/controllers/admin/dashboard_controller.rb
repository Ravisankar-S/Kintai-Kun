module Admin
  class DashboardController < ApplicationController
    before_action :require_admin!

    def index
      @users =
        User.includes(:work_logs)
            .order(:name)

      @total_logs =
        WorkLog.for_month(
          Date.current.year,
          Date.current.month
        ).count

      @overtime_users =
        User.joins(:work_logs)
            .where(work_logs: {
              is_overtime: true,
              clocked_in_at: Date.current.beginning_of_week(:monday)..
                             Date.current.end_of_week(:monday)
            })
            .distinct
    end

    private

    def require_admin!
      unless current_user.role == "admin"
        redirect_to root_path,
                    alert: t("admin.access_denied")
      end
    end
  end
end