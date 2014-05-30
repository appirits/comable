module Comable
  class CartItem < ActiveRecord::Base
    belongs_to :customer, class_name: Comable::Customer.model.name
    belongs_to :stock, class_name: Comable::Stock.model.name

    validates "#{Comable::Customer.model_name.singular}_id", uniqueness: { scope: ["#{Comable::Customer.model_name.singular}_id", "#{Comable::Stock.model_name.singular}_id"] }

    def product
      # TODO: if stock.comable_stock_flag
      stock.product.tap { |obj| obj.comable(:product) }
    end

    def price
      stock.price * quantity
    end
  end
end
