module Admin
  class DashboardController < ApplicationController
    before_action :require_admin!

    def index
      @users = User.left_joins(:work_logs)
                   .select('users.*, COUNT(work_logs.id) AS work_logs_count')
                   .group('users.id')
                   .order(:name)
                   .page(params[:page]).per(15)

      # Live search support
      if params[:query].present?
        q = "%#{params[:query].downcase}%"
        @users = User.left_joins(:work_logs)
                     .select('users.*, COUNT(work_logs.id) AS work_logs_count')
                     .where("LOWER(users.name) LIKE ? OR LOWER(users.email) LIKE ?", q, q)
                     .group('users.id')
                     .order(:name)
                     .page(params[:page]).per(15)
      end

      @total_users    = User.count
      @total_logs     = WorkLog.for_month(Date.today.year, Date.today.month).count
      @overtime_entries_count = WorkLog.where(is_overtime: true)
                                       .where('clocked_in_at >= ?', Date.today.beginning_of_week)
                                       .count

      @overtime_logs_this_week = WorkLog.includes(:user)
                                        .where(is_overtime: true)
                                        .where('clocked_in_at >= ?', Date.today.beginning_of_week)
                                        .order(clocked_in_at: :desc)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    private

    def require_admin!
      unless current_user&.role == 'admin'
        redirect_to root_path, alert: t('admin.access_denied')
      end
    end
  end
end