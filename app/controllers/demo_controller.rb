class DemoController < ApplicationController
  skip_before_action :authenticate_user!

  def refresh
    unless params[:token] == ENV['DEMO_REFRESH_TOKEN']
      render plain: "Forbidden.", status: :forbidden
      return
    end

    begin
      require 'rake'
      Rails.application.load_tasks if Rake::Task.tasks.empty?
      Rake.application.rake_require 'tasks/demo_data'
      Rake::Task['demo:refresh'].reenable
      Rake::Task['demo:refresh'].invoke
      render plain: "Done. Logs refreshed relative to #{Date.today}."
    rescue StandardError => e
      render plain: "Error: #{e.message}", status: 500
    end
  end
end
