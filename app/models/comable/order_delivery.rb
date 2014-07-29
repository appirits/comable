module Comable
  class OrderDelivery < ActiveRecord::Base
    include Decoratable

    belongs_to :order, class_name: Comable::Order.name, foreign_key: Comable::Order.table_name.singularize.foreign_key
    has_many :order_details, dependent: :destroy, class_name: Comable::OrderDetail.name, foreign_key: table_name.singularize.foreign_key

    accepts_nested_attributes_for :order_details

    delegate :customer, to: :order
  end
end
