class Comable::CashRegister
  class Comable::InvalidOrder < StandardError; end

  attr_accessor :customer
  attr_accessor :order

  def initialize(attributes)
    @customer = attributes[:customer]
    @order = @customer.orders.build(attributes[:order_attributes])
  end

  def build_order
    assign_default_attributes_to_order
    raise Comable::InvalidOrder if invalid
    order
  end

  def create_order
    order = build_order
    order.save
    customer.reset_cart
    order
  end

  def valid
    cart = customer.cart

    order.order_deliveries.map(&:order_details).flatten.each do |order_detail|
      next unless order_detail.product
      result = cart.reject! {|cart_item| cart_item.product.origin == order_detail.product.origin }
      return false if result.nil?
    end

    cart.empty?
  end

  def invalid
    not valid
  end

  private

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

    assign_default_attributes_to_order_details(order_delivery) if first_order_detail?(order_delivery)
  end

  def assign_default_attributes_to_order_details(order_delivery)
    customer.cart.each do |cart_item|
      product_colmun_name = Comable::Product.table_name.singularize

      order_delivery.order_details.build(
        :"#{product_colmun_name}_id" => cart_item.product.id,
        :quantity => cart_item.quantity,
        :price => cart_item.price
      )
    end
  end

  def first_order_detail?(order_delivery)
    order.order_deliveries.map(&:order_details).all?(&:empty?)
  end
end
