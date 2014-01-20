module Comable
  class CartItem < ActiveRecord::Base
    belongs_to ::Comable::Engine::config.customer_table.to_s.singularize.to_sym
    belongs_to ::Comable::Engine::config.product_table.to_s.singularize.to_sym

    def price
      self.product.price * self.quantity
    end
  end
end
