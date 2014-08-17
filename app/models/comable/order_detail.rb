module Comable
  class OrderDetail < ActiveRecord::Base
    include Decoratable

    belongs_to :stock, class_name: Comable::Stock.name, foreign_key: Comable::Stock.table_name.singularize.foreign_key
    belongs_to :order_delivery, class_name: Comable::OrderDelivery.name, foreign_key: Comable::OrderDelivery.table_name.singularize.foreign_key

    delegate :product, to: :stock
    delegate :guest_token, to: :order_delivery
    delegate :complete?, to: :order_delivery

    def before_complete
      save_price
      decrement_stock
    end

    # 時価を取得
    def current_price
      stock.price
    end

    # 時価小計を取得
    def current_subtotal_price
      current_price * quantity
    end

    # 売価小計を取得
    def subtotal_price
      price * quantity
    end

    def decrement_stock
      stock.decrement!(quantity: quantity)
    end

    def save_price
      self.price = stock.price
    end
  end
end
