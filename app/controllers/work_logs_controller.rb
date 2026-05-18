class WorkLogsController < ApplicationController
  def index
    @work_logs =
      current_user.work_logs
                  .order(clocked_in_at: :desc)
  end

  def export_csv
    @work_logs =
      current_user.work_logs
                  .completed
                  .order(clocked_in_at: :asc)

    respond_to do |format|
      format.csv do
        filename =
          "kintai_#{Date.today.strftime('%Y_%m')}.csv"

        response.headers[
          "Content-Disposition"
        ] =
          "attachment; filename=#{filename}"
      end
    end
  end

end