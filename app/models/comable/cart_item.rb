module Comable
  class CartItem < ActiveRecord::Base
    belongs_to Comable::Engine::config.customer_table.to_s.singularize.to_sym
    belongs_to Comable::Engine::config.product_table.to_s.singularize.to_sym

    validates "#{Comable::Engine::config.customer_table.to_s.singularize}_id", uniqueness: { scope: "#{Comable::Engine::config.product_table.to_s.singularize}_id" }

    def customer
      origin_customer = self.send(Comable::Engine::config.customer_table.to_s.singularize)
      Comable::Customer.new(origin_customer)
    end

    def price
      self.product.price * self.quantity
    end
  end
end
