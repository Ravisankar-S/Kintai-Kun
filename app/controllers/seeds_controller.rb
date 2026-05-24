class SeedsController < ApplicationController
  skip_before_action :authenticate_user!

  def run
    if User.exists?
      render plain: "Already seeded. Remove this route now."
      return
    end

    load Rails.root.join('db/seeds.rb')
    render plain: "Seeded successfully. REMOVE THIS ROUTE NOW."
  end
end
