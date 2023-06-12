Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :product_categories, only: [:index, :new, :create, :edit, :update]
  resources :products, only: [:new, :create, :show, :index, :edit, :update]

  resources :customer_areas, only: [:index]
  resources :my_infos, only: [:index]
end
