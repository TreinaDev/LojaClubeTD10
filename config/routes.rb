Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :product_categories, only: [:index, :new, :create, :edit, :update]
  resources :products, only: [:new, :create, :show, :index, :edit, :update]
  resources :favorites, only: [:create, :destroy]

  resources :customer_areas, only: [:index] 
  get "me", to: "customer_areas#me"
  get "favorite_tab", to: "customer_areas#favorite_tab"
end
