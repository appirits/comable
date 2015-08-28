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
        post :import
      end
    end

    resources :orders do
      collection do
        get :export
      end

      member do
        post :cancel
        post :resume
        post :cancel_payment
        post :resume_payment
        post :ship
        post :cancel_shipment
        post :resume_shipment
      end
    end

    resources :categories
    resources :pages

    resources :navigations do
      post :search_linkable_ids, on: :collection
    end

    resources :users
    resources :shipment_methods
    resources :payment_methods
    resources :trackers

    resources :themes do
      member do
        get 'tree', action: :tree, as: :tree
        get 'file/*path', action: :show_file, constraints: { path: /.+/, format: false }, as: :file
        put 'file/*path', action: :update_file, constraints: { path: /.+/, format: false }
        put :use
      end
    end

    resource :store, controller: :store, only: [:show, :edit, :update]

    devise_for :users, path: :user, class_name: Comable::User.name, module: :devise, router_name: :comable, controllers: {
      sessions: 'comable/admin/user_sessions'
    }

    get :profile, controller: :users
  end
end
