module Comable
  class OrderDetail < ActiveRecord::Base
    belongs_to Comable::Product.model_name.singular.to_sym
    belongs_to :comable_order_deliveries, class_name: 'Comable::OrderDelivery'

    after_create :decrement_stock

    private

    def decrement_stock
      product = self.send(Comable::Product.model_name.singular)
      stock = product.stocks.first
      stock.decrement_quantity!
    end
  end
end
