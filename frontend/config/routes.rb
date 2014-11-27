Comable::Core::Engine.routes.draw do
  get '/' => 'products#index'

  resources :products

  resource :cart do
    collection do
      post :add
    end
  end

  resource :order do
    collection do
      get :orderer
      put :orderer
      get :delivery
      put :delivery
      get :shipment
      put :shipment
      get :payment
      put :payment
      get :confirm
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
