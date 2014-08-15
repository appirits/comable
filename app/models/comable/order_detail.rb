module Comable
  class OrderDetail < ActiveRecord::Base
    include Decoratable

    belongs_to :stock, class_name: Comable::Stock.name, foreign_key: Comable::Stock.table_name.singularize.foreign_key
    belongs_to :order_delivery, class_name: Comable::OrderDelivery.name, foreign_key: Comable::OrderDelivery.table_name.singularize.foreign_key

    delegate :product, to: :stock
    delegate :guest_token, to: :order_delivery
    delegate :complete?, to: :order_delivery

    def subtotal_price
      price * quantity
    end

    def decrement_stock
      stock.decrement!(quantity: quantity)
    end

    # TODO: stock.price or price な専用メソッドを用意する
    module PriceMethodOverrider
      def price
        return super if complete?
        stock.price
      end
    end
    prepend PriceMethodOverrider
  end
end
