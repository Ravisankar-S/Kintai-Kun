Rails.application.routes.draw do
  
  resources :work_logs, only: [:index]

  get "dashboard/index"
  get "pages/landing"
  root "pages#landing"

  devise_for :users

  get "/dashboard", to: "dashboard#index"
  
  post "/clock_in",  to: "punches#clock_in"
  post "/clock_out", to: "punches#clock_out"
end