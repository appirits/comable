Comable::Engine.routes.draw do
  get '/' => 'products#index'

  resources :products

  resource :cart do
    collection do
      post :add
    end
  end
end
