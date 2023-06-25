Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations' }
  root "home#index"

  resources :product_categories, only: [:index, :new, :create, :edit, :update] do
    member do
      patch :deactivate
      patch :reactivate
    end
  end

  resources :addresses, only: [:new, :create, :edit, :update, :destroy] do
    post :set_default, on: :member
  end

  resources :product_subcategories, only: [:new, :create, :edit, :update] do
    get :subcategories, on: :member
  end

  resources :favorites, only: [:create, :destroy]

  resources :products, only: [:new, :create, :show, :index, :edit, :update] do
    member do
      patch :deactivate
      patch :reactivate
    end
    collection do
      patch :deactivate_all
      patch :reactivate_all
    end
    get 'search', on: :collection
  end

  resources :promotional_campaigns, only: [:index, :new, :create, :show, :edit, :update] do
    resources :campaign_categories, only:  [:create, :destroy]
  end

  get "customer_areas", to: "customer_areas#index"

  resources :shopping_carts, only: [:show] do
    post "add", on: :collection
    post "remove", on: :collection
    post "remove_all", on: :collection
    get "close", to: "shopping_carts#close"
  end

  resources :orders, only: [:index, :show]

  get "me", to: "customer_areas#me"
  get "client_addresses", to: "customer_areas#addresses"
  get "favorite_tab", to: "customer_areas#favorite_tab"
  post "update_phone_number", to: "users#update_phone"

  resources :seasonal_prices, only: [:index, :new, :create, :edit, :update, :destroy]
  post "close_order", to: "orders#close_order"
end
