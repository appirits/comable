Comable::Core::Engine.routes.draw do
  scope :admin do
    get '/' => 'admin/products#index'
  end
end
