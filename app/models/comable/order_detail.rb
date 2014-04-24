module Comable
  class OrderDetail < ActiveRecord::Base
    belongs_to Comable::Product.model_name.singular.to_sym
    belongs_to :comable_order_deliveries, class_name: 'Comable::OrderDelivery'
  end
end
