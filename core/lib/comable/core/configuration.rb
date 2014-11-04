module Comable
  module Core
    module Configuration
      mattr_accessor :devise_strategies
      @@devise_strategies = {
        customer: [:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable]
      }
    end
  end
end
