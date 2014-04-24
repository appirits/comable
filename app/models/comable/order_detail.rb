module Comable
  class OrderDetail < ActiveRecord::Base
    belongs_to Comable::Engine::config.product_table.to_s.singularize.to_sym
    belongs_to :comable_order_deliveries, class_name: 'Comable::OrderDelivery'
  end
end
