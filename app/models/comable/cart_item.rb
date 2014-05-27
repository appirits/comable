module Comable
  class CartItem < ActiveRecord::Base
    belongs_to Comable::Customer.model_name.singular.to_sym
    belongs_to Comable::Stock.model_name.singular.to_sym

    validates "#{Comable::Customer.model_name.singular}_id", uniqueness: { scope: ["#{Comable::Customer.model_name.singular}_id", "#{Comable::Stock.model_name.singular}_id"] }

    def product
      stock = send(Comable::Stock.model_name.singular)
      # TODO: if stock.comable_stock_flag
      stock.product.tap { |obj| obj.comable_product }
    end

    def price
      stock = send(Comable::Stock.model_name.singular)
      stock.price * quantity
    end
  end
end
