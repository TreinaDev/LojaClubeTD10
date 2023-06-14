Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :product_categories, only: [:index, :new, :create, :edit, :update]
  resources :products, only: [:new, :create, :show, :index, :edit, :update]
  resources :promotional_campaigns, only: [:index, :new, :create]

  resources :customer_areas, only: [:index]
  get "me", to: "customer_areas#me"
end
