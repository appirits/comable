Rails.application.routes.draw do
  mount Comable::Core::Engine, at: '/comable'
  mount JasmineRails::Engine, at: '/specs' if defined? JasmineRails
end
