Rails.application.routes.draw do
  mount Comable::Core::Engine, at: '/comable'
  mount Ckeditor::Engine => '/ckeditor'
end
