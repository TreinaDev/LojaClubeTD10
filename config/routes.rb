Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  resources :products, only: [:new, :create, :show, :index]
end
