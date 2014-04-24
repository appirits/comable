module Comable
  class CartItem < ActiveRecord::Base
    belongs_to Comable::Customer.model_name.singular.to_sym
    belongs_to Comable::Product.model_name.singular.to_sym

    validates "#{Comable::Customer.model_name.singular}_id", uniqueness: { scope: "#{Comable::Product.model_name.singular}_id" }

    def price
      self.product.price * self.quantity
    end
  end
end
