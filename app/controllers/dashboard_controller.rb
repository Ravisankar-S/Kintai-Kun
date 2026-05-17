class DashboardController < ApplicationController
  def index
    @active_log = current_user.work_logs.active.first
  end
end