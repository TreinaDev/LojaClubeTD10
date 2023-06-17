Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }
  root "home#index"

  resources :product_categories, only: [:index, :new, :create, :edit, :update] do
    member do
      patch :deactivate
      patch :reactivate
    end
  end
  resources :products, only: [:new, :create, :show, :index, :edit, :update]
  resources :promotional_campaigns, only: [:index, :new, :create, :show, :edit, :update]

  resources :customer_areas, only: [:index]

  resources :shopping_carts, only: [:show] do
    post "add", on: :collection
    post "remove", on: :collection
    post "remove_all", on: :collection
  end

  get "me", to: "customer_areas#me"
  post "update_phone_number", to: "users#update_phone"
end
