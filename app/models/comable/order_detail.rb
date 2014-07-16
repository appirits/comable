module Comable
  class OrderDetail < ActiveRecord::Base
    belongs_to :stock, utusemi: :force, class_name: Comable::Stock.model_name, foreign_key: Comable::Stock.foreign_key
    belongs_to :comable_order_deliveries, class_name: 'Comable::OrderDelivery'

    after_create :decrement_quantity!
    delegate :decrement_quantity!, to: :stock

    delegate :product, to: :stock
  end
end
