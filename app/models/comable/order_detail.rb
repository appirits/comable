module Comable
  class OrderDetail < ActiveRecord::Base
    belongs_to :comable_stock, class_name: Comable::Stock.model_name, foreign_key: Comable::Stock.foreign_key
    belongs_to :comable_order_deliveries, class_name: 'Comable::OrderDelivery'

    after_create :decrement_stock

    def stock
      stock = comable_stock
      stock.comable(:stock)
    end

    delegate :product, to: :stock

    private

    def decrement_stock
      stock.decrement_quantity!
    end
  end
end
