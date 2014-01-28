module Comable
  class OrderDelivery < ActiveRecord::Base
    belongs_to :comable_order, class_name: 'Comable::Order'
    has_many :comable_order_details, dependent: :destroy, class_name: 'Comable::OrderDetail', foreign_key: 'comable_order_delivery_id'

    alias_method :order, :comable_order
    alias_method :order_details, :comable_order_details

    after_create :create_order_details

    private

    def create_order_details
      customer = self.order.send(Comable::Engine::config.customer_table.to_s.singularize)
      customer.cart.each do |cart_item|
        product_colmun_name = Comable::Engine::config.product_table.to_s.singularize
        product = cart_item.send(product_colmun_name)

        self.order_details.create(
          :"#{product_colmun_name}_id" => product.id,
          :quantity => cart_item.quantity,
          :price => cart_item.price
        )
      end
    end
  end
end
