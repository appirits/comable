Comable::Engine.routes.draw do
  get '/' => 'products#index'
  resources :products
end
