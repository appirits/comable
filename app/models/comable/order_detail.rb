module Comable
  class OrderDetail < ActiveRecord::Base
    utusemi!

    belongs_to :stock, class_name: Comable::Stock.name, foreign_key: Comable::Stock.name.foreign_key
    belongs_to :comable_order_deliveries, class_name: 'Comable::OrderDelivery'

    after_create :decrement_quantity!
    delegate :decrement_quantity!, to: :stock

    delegate :product, to: :stock
  end
end
