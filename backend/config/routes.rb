Comable::Core::Engine.routes.draw do
  namespace :admin do
    root to: 'dashboard#show'

    resource :dashboard, only: :show

    resources :products do
      resources :stocks
    end
    resources :stocks

    resources :categories
    resources :orders
    resources :customers
    resources :shipment_methods
    resources :payment_methods
    resource :store, controller: :store, only: [:show, :edit, :update]

    devise_for :customer, path: :user, class_name: Comable::Customer.name, module: :devise
  end
end
