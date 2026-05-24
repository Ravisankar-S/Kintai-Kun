class WorkLogsController < ApplicationController
  def index
    @month = if params[:month].present?
      Date.parse("#{params[:month]}-01")
    else
      Date.current.beginning_of_month
    end

    # Last 12 months for the dropdown (current month first)
    @month_options = 12.times.map { |i| Date.current.beginning_of_month - i.months }

    @work_logs =
      current_user.work_logs
                  .for_month(@month.year, @month.month)
                  .order(clocked_in_at: :desc)
                  .page(params[:page])
                  .per(20)
  end

  def export_csv
    month = if params[:month].present?
      Date.parse("#{params[:month]}-01")
    else
      Date.current.beginning_of_month
    end

    @work_logs =
      current_user.work_logs
                  .for_month(month.year, month.month)
                  .completed
                  .order(clocked_in_at: :asc)

    respond_to do |format|
      format.csv do
        safe_name = current_user.name.to_s.strip.gsub(/[^a-zA-Z0-9]/, "_")
        filename  = "kintai_#{safe_name}_#{month.strftime('%Y-%m')}.csv"
        response.headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
        render template: "work_logs/export_csv"
      end
    end
  end
end