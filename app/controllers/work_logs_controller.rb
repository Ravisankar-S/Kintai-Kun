class WorkLogsController < ApplicationController
  def index
    @work_logs =
      current_user.work_logs
                  .order(clocked_in_at: :desc)
  end
end