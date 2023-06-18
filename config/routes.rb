Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :product_categories, only: [:index, :new, :create, :edit, :update] do
    member do 
      patch :deactivate
      patch :reactivate
    end
  end
  
  resources :products, only: [:new, :create, :show, :index, :edit, :update]
  resources :promotional_campaigns, only: [:index, :new, :create, :show, :edit, :update]
  resources :addresses, only: [:new, :create, :edit, :update, :destroy] do
    patch :set_default, on: :member
  end

  resources :customer_areas, only: [:index]
  get "me", to: "customer_areas#me"
  get "client_addresses", to: "customer_areas#addresses"
  post "update_phone_number", to: "users#update_phone"
end
