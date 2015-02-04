module Comable
  module Core
    module Configuration
      mattr_accessor :devise_strategies
      @@devise_strategies = {
        customer: [:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable]
      }

      mattr_accessor :products_per_page
      @@products_per_page = 15

      mattr_accessor :orders_per_page
      @@orders_per_page = 5
    end
  end
end
