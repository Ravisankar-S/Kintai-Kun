Rails.application.routes.draw do
  
  resources :work_logs, only: [:index] do
    collection do
      get :export_csv
    end
  end

  get "dashboard/index"
  get "pages/landing"
  root "pages#landing"

  devise_for :users

  get "/dashboard", to: "dashboard#index"

  get "/profile",
    to: "users#edit",
    as: :edit_profile

  patch "/profile",
      to: "users#update",
      as: :update_profile
  
  post "/clock_in",  to: "punches#clock_in"
  post "/clock_out", to: "punches#clock_out"

  post "/locale", to: "application#set_locale_action"
end