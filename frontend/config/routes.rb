Comable::Core::Engine.routes.draw do
  get '/' => 'products#index'

  resources :products

  resource :cart do
    collection do
      post :add
    end
  end

  resource :order, only: [:create] do
    collection do
      get 'new', as: :new
      get ':state', action: :edit, as: :next
      put ':state', action: :update
    end
  end

  devise_for :customer, path: :member, class_name: Comable::Customer.name, module: :devise

  resource :customer, path: :member do
    member do
      get :addresses
      put :addresses
    end
  end
end
