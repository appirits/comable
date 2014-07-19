module Comable
  class OrderDelivery < ActiveRecord::Base
    utusemi!

    belongs_to :comable_order, class_name: 'Comable::Order'
    has_many :comable_order_details, dependent: :destroy, class_name: 'Comable::OrderDetail', foreign_key: 'comable_order_delivery_id'

    accepts_nested_attributes_for :comable_order_details

    alias_method :order, :comable_order
    alias_method :order_details, :comable_order_details

    delegate :customer, to: :order
  end
end
