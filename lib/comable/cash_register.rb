module Comable
  class InvalidOrder < StandardError; end

  class CashRegister
    include ActiveModel::Validations

    validate :valid_stock

    attr_accessor :customer
    attr_accessor :order

    def initialize(attributes)
      @customer = attributes[:customer]
      @order = @customer.orders.incomplete.first  ||  @customer.orders.build
    end

    def build_order
      assign_default_attributes_to_order
      fail Comable::InvalidOrder, errors.full_messages.join("\n") if invalid?
      order
    end

    def create_order
      # TODO: トランザクションの追加
      order = build_order
      order.save!
      customer.reset_cart
      order
    end

    private

    def assign_default_attributes_to_order
      order.order_deliveries.build if order.order_deliveries.empty?
      assign_default_attributes_to_order_deliveries
    end

    def assign_default_attributes_to_order_deliveries
      order.order_deliveries.each do |order_delivery|
        assign_default_attributes_to_order_delivery(order_delivery)
      end
    end

    def assign_default_attributes_to_order_delivery(order_delivery)
      assign_default_attributes_to_order_details(order_delivery) if first_order_detail?
    end

    def assign_default_attributes_to_order_details(order_delivery)
      order_delivery.order_details.each do |order_detail|
        order_detail.update_attributes(
          price: order_detail.stock.price
        )
      end
    end

    def first_order_detail?
      order.order_deliveries.map(&:order_details).all?(&:empty?)
    end
  end
end
