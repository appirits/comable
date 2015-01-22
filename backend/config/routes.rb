Comable::Core::Engine.routes.draw do
  namespace :admin do
    root to: 'products#index'

    resources :products
    resources :categories
    resources :orders
    resources :customers
    resources :shipment_methods
    resource :store, controller: :store, only: [:show, :edit, :update]
  end
end
