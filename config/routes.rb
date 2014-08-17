Comable::Engine.routes.draw do
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
      get :confirm
    end
  end
end
