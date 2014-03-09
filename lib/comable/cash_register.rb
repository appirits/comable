class Comable::CashRegister
  class Comable::InvalidOrder < StandardError; end

  attr_accessor :customer
  attr_accessor :order

  def initialize(attributes)
    @customer = attributes[:customer]
    @order = attributes[:order]
  end

  def exec
    raise Comable::InvalidOrder if invalid
    assign_default_attributes_to_order
    order.save
  end

  def valid
    # TODO: このメソッド内ではカートの中身をいじらないようにすべき
    order.order_deliveries.map(&:order_details).flatten.each do |order_detail|
      next unless order_detail.product
      return false unless customer.remove_cart_item(order_detail.product)
    end
    true
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
      product_colmun_name = Comable::Engine::config.product_table.to_s.singularize
      product = cart_item.send(product_colmun_name)

      order_delivery.order_details.build(
        :"#{product_colmun_name}_id" => product.id,
        :quantity => cart_item.quantity,
        :price => cart_item.price
      )

      customer.remove_cart_item(product)
    end
  end

  def first_order_detail?(order_delivery)
    return false unless order.order_deliveries.first == order_delivery
    return false if order_delivery.order_details.any?
    true
  end
end
