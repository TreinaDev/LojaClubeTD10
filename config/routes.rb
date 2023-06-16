Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :product_categories, only: [:index, :new, :create, :edit, :update]
  resources :product_subcategories, only: [:new, :create, :edit, :update] do
    get :subcategories, on: :member
  end

  resources :products, only: [:new, :create, :show, :index, :edit, :update]

  resources :customer_areas, only: [:index]
  get "me", to: "customer_areas#me"
end
