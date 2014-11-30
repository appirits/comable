module Comable
  class OrderDelivery < ActiveRecord::Base
    belongs_to :order, class_name: Comable::Order.name, foreign_key: Comable::Order.table_name.singularize.foreign_key, inverse_of: :order_deliveries
    has_many :order_details, dependent: :destroy, class_name: Comable::OrderDetail.name, foreign_key: table_name.singularize.foreign_key, inverse_of: :order_delivery

    accepts_nested_attributes_for :order_details

    delegate :customer, to: :order
    delegate :guest_token, to: :order
    delegate :completed?, to: :order

    def complete
      order_details.each(&:complete)
    end

    # 氏名を取得
    def full_name
      [family_name, first_name].join(' ')
    end
  end
end
