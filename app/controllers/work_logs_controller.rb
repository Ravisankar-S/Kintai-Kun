class WorkLogsController < ApplicationController
  def index
    @month = if params[:month].present?
      Date.parse("#{params[:month]}-01")
    else
      Date.current.beginning_of_month
    end

    @month_options =
      12.times.map { |i| (@month - i.months).beginning_of_month }

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
    end

    scope = current_user.work_logs
    scope = scope.for_month(month.year, month.month) if month

    @work_logs =
      scope.order(clocked_in_at: :asc)

    respond_to do |format|
      format.csv do
        safe_name = current_user.name.to_s.strip.gsub(/\s+/, "_")
        filename =
          "kintai_#{safe_name}_#{(month || Date.current).strftime('%Y-%m')}.csv"

        response.headers[
          "Content-Disposition"
        ] =
          "attachment; filename=#{filename}"
      end
    end
  end

end