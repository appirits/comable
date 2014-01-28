module Comable
  class OrderDelivery < ActiveRecord::Base
    belongs_to :comable_order, class_name: 'Comable::Order'
  end
end
