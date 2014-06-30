module Comable
  class CartItem < ActiveRecord::Base
    belongs_to :customer, class_name: Comable::Customer.model.name, foreign_key: Comable::Customer.foreign_key
    belongs_to :comable_stock, class_name: Comable::Stock.model.name, foreign_key: Comable::Stock.foreign_key

    validates Comable::Customer.foreign_key, uniqueness: { scope: [Comable::Customer.foreign_key, Comable::Stock.foreign_key] }

    include Comable::ColumnsMapper

    def stock
      return comable_stock unless respond_to?(:comable_values)
      return comable_stock unless comable_values[:flag]
      stock = comable_stock
      return if stock.nil?
      stock.comable(:stock)
      stock
    end

    delegate :product, to: :stock

    def price
      stock.price * quantity
    end
  end
end
