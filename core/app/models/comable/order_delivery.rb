module Comable
  class OrderDelivery < ActiveRecord::Base
    belongs_to :order, class_name: Comable::Order.name, foreign_key: Comable::Order.table_name.singularize.foreign_key
    has_many :order_details, dependent: :destroy, class_name: Comable::OrderDetail.name, foreign_key: table_name.singularize.foreign_key

    delegate :customer, to: :order
    delegate :guest_token, to: :order
    delegate :complete?, to: :order

    def save_to_complete
      order_details.each(&:save_to_complete)
    end

    # 氏名を取得
    def full_name
      [family_name, first_name].join(' ')
    end
  end
end
