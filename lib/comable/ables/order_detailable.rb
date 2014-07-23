module Comable
  module Able
    module OrderDetailable
      def self.included(base)
        base.instance_eval do
          belongs_to :stock, class_name: Comable::Stock.name, foreign_key: Comable::Stock.name.foreign_key
          belongs_to :order_delivery, class_name: Comable::OrderDelivery.name

          after_create :decrement_quantity!
          delegate :decrement_quantity!, to: :stock

          delegate :product, to: :stock
        end
      end
    end
  end
end
