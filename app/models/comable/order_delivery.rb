module Comable
  class OrderDelivery < ActiveRecord::Base
    belongs_to :comable_order, class_name: 'Comable::Order'
    has_many :comable_order_details, dependent: :destroy, class_name: 'Comable::OrderDetail', foreign_key: 'comable_order_delivery_id'

    accepts_nested_attributes_for :comable_order_details

    alias_method :order, :comable_order
    alias_method :order_details, :comable_order_details

    before_create :assign_default_attributes

    def customer
      self.order.send(Comable::Engine::config.customer_table.to_s.singularize)
    end

    private

    def assign_default_attributes
      self.family_name ||= customer.family_name
      self.first_name ||= customer.first_name

      assign_default_attributes_to_order_details if first_order_detail?
    end

    def assign_default_attributes_to_order_details
      customer.cart.each do |cart_item|
        product_colmun_name = Comable::Engine::config.product_table.to_s.singularize
        product = cart_item.send(product_colmun_name)

        self.order_details.build(
          :"#{product_colmun_name}_id" => product.id,
          :quantity => cart_item.quantity,
          :price => cart_item.price
        )

        customer.remove_cart_item(product)
      end
    end

    def first_order_detail?
      self.order.order_deliveries.count.zero? && self.order_details.empty?
    end
  end
end
