Comable::Core::Engine.routes.draw do
  namespace :admin do
    root to: 'products#index'

    resources :products
    resources :orders
    resources :shipment_methods
    resource :store, controller: :store
  end
end
