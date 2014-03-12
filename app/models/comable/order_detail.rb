module Comable
  class OrderDetail < ActiveRecord::Base
    belongs_to Comable::Product.table_name.singularize.to_sym, class_name: "::#{Comable::Product.origin_class.name}"
    belongs_to :comable_order_deliveries, class_name: 'Comable::OrderDelivery'

    alias_method :product_orgin, Comable::Product.table_name.singularize.to_sym

    def product
      if Comable::Product.mapping?
        Comable::Product.new(self.product_orgin)
      else
        self.product_orgin
      end
    end
  end
end
