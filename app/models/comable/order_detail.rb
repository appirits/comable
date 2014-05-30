module Comable
  class OrderDetail < ActiveRecord::Base
    belongs_to :stock, class_name: Comable::Stock.model.name
    belongs_to :comable_order_deliveries, class_name: 'Comable::OrderDelivery'

    after_create :decrement_stock

    def product
      # TODO: if stock.comable_stock_flag
      stock.product.tap { |obj| obj.comable(:product) }
    end

    private

    def decrement_stock
      stock.decrement_quantity!
    end
  end
end
