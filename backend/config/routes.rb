Comable::Core::Engine.routes.draw do
  namespace :admin do
    root to: 'dashboard#show'

    resource :dashboard, only: :show

    resources :products do
      resources :stocks

      collection do
        get :export
        post :import
      end
    end

    resources :stocks do
      collection do
        get :export
      end
    end

    resources :orders do
      collection do
        get :export
      end
    end

    resources :categories
    resources :users
    resources :shipment_methods
    resources :payment_methods
    resource :store, controller: :store, only: [:show, :edit, :update]

    devise_for :user, path: :user, class_name: Comable::User.name, module: :devise, controllers: {
      sessions: 'comable/admin/user_sessions'
    }
  end
end
