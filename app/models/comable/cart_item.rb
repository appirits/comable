module Comable
  class CartItem < ActiveRecord::Base
    belongs_to Comable::Customer.model_name.singular.to_sym
    belongs_to Comable::Stock.model_name.singular.to_sym

    validates "#{Comable::Customer.model_name.singular}_id", uniqueness: { scope: [ "#{Comable::Customer.model_name.singular}_id", "#{Comable::Stock.model_name.singular}_id" ] }

    def price
      stock = self.send(Comable::Stock.model_name.singular)
      stock.price * self.quantity
    end
  end
end
