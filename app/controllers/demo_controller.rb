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
      
      # Automatically run pending database migrations (useful for Render Free Tier)
      Rake::Task['db:migrate'].invoke
      
      Rake.application.rake_require 'tasks/demo_data'
      Rake::Task['demo:refresh'].reenable
      Rake::Task['demo:refresh'].invoke
      render plain: "Done. Database migrated and logs refreshed relative to #{Date.today}."
    rescue StandardError => e
      render plain: "Error: #{e.message}", status: 500
    end
  end
end
