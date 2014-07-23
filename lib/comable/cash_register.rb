module Comable
  class InvalidOrder < StandardError; end

  class CashRegister
    attr_accessor :customer
    attr_accessor :order

    def initialize(attributes)
      @customer = attributes[:customer]
      @order = @customer.orders.build(attributes[:order_attributes])
    end

    def build_order
      assign_default_attributes_to_order
      fail Comable::InvalidOrder if invalid
      order
    end

    def create_order
      order = build_order
      order.save
      customer.reset_cart
      order
    end

    def valid
      valid_cart && valid_stock
    end

    def invalid
      !valid
    end

    private

    def valid_cart
      cart = customer.cart

      order.order_deliveries.map(&:order_details).flatten.each do |order_detail|
        next unless order_detail.stock
        result = cart.reject! { |cart_item| cart_item.stock == order_detail.stock }
        return false if result.nil?
      end

      cart.empty?
    end

    def valid_stock
      order.order_deliveries.map(&:order_details).flatten.each do |order_detail|
        next unless order_detail.stock
        return false unless order_detail.stock.unsold?
      end
    end

    def assign_default_attributes_to_order
      order.family_name ||= customer.family_name
      order.first_name ||= customer.first_name

      order.order_deliveries.build if order.order_deliveries.empty?
      assign_default_attributes_to_order_deliveries
    end

    def assign_default_attributes_to_order_deliveries
      order.order_deliveries.each do |order_delivery|
        assign_default_attributes_to_order_delivery(order_delivery)
      end
    end

    def assign_default_attributes_to_order_delivery(order_delivery)
      order_delivery.family_name ||= customer.family_name
      order_delivery.first_name ||= customer.first_name

      assign_default_attributes_to_order_details(order_delivery) if first_order_detail?
    end

    def assign_default_attributes_to_order_details(order_delivery)
      customer.cart.each do |cart_item|
        order_delivery.order_details.build(
          Comable::Stock.name.foreign_key => cart_item.stock.id,
          :quantity => cart_item.quantity,
          :price => cart_item.price
        )
      end
    end

    def first_order_detail?
      order.order_deliveries.map(&:order_details).all?(&:empty?)
    end
  end
end
