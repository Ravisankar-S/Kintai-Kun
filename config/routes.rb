Rails.application.routes.draw do
  get "dashboard/index"
  get "pages/landing"
  root "pages#landing"

  devise_for :users

  get "/dashboard", to: "dashboard#index"
end