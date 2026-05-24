Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  resources :work_logs, only: [:index] do
    collection do
      get :export_csv
    end
  end

  get "dashboard/index"
  get "pages/landing"
  root "pages#landing"
  get "/auth", to: "pages#auth"

  devise_for :users

  get "/dashboard", to: "dashboard#index"

  get "/profile",
    to: "users#edit",
    as: :edit_profile

  patch "/profile",
      to: "users#update",
      as: :update_profile

    delete "/profile/avatar",
      to: "users#destroy_avatar",
      as: :destroy_avatar
  
  post "/clock_in",  to: "punches#clock_in"
  post "/clock_out", to: "punches#clock_out"
  post "/take_break", to: "punches#take_break"
  post "/resume_work", to: "punches#resume_work"

  post "/locale", to: "application#set_locale_action", as: :set_locale
  post "/timezone", to: "application#set_timezone_action", as: :set_timezone

  namespace :admin do
    root "dashboard#index"
    get "dashboard", to: "dashboard#index", as: :dashboard

    resources :users,
            only: [:index, :show]
  end
end