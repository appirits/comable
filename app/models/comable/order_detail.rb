module Comable
  class OrderDetail < ActiveRecord::Base
    include Decoratable

    belongs_to :stock, class_name: Comable::Stock.name, foreign_key: Comable::Stock.table_name.singularize.foreign_key
    belongs_to :order_delivery, class_name: Comable::OrderDelivery.name, foreign_key: Comable::OrderDelivery.table_name.singularize.foreign_key

    after_create :decrement_quantity!

    delegate :product, to: :stock

    def decrement_quantity!
      stock.decrement_quantity!(quantity: quantity)
    end
  end
end
