class PagesController < ApplicationController
  skip_before_action :authenticate_user!,
                   only: [:landing, :auth]
  
  def landing
  end

  def auth
  end
end
