Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :customer_area, only: [:index]
end
