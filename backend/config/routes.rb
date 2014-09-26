Comable::Core::Engine.routes.draw do
  namespace :admin do
    root to: 'products#index'

    resources :shipment_methods
    resource :store, controller: :store
  end
end
