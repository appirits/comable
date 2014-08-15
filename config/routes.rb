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
      patch :orderer
      get :delivery
      patch :delivery
      get :confirm
    end
  end
end
