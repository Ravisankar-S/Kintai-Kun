Rails.application.routes.draw do
  get "pages/landing"
  root "pages#landing"

  devise_for :users
end