Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :product_categories, only: [:index, :new, :create, :edit, :update] do
    member do 
      patch :deactivate
      patch :reactivate
    end
  end
end
