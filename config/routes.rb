Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :product_categories, only: [:index, :new, :create, :edit, :update]
  resources :products, only: [:new, :create, :show, :index, :edit, :update]
end
