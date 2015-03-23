Rails.application.routes.draw do
  mount Comable::Core::Engine, at: '/comable'
end
