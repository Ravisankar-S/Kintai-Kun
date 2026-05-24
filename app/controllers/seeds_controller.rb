class SeedsController < ApplicationController
  skip_before_action :authenticate_user!

  def run
    # completely wipe the DB to ensure fresh seeds
    WorkLog.destroy_all
    User.destroy_all

    # Run the seeds
    load Rails.root.join('db/seeds.rb')
    render plain: "Database wiped and seeded successfully. REMOVE THIS ROUTE NOW."
  end
end
