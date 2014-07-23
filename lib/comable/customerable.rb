module Comable
  module Customerable
    def self.included(base)
      base.instance_eval do
        has_many :comable_orders, class_name: 'Comable::Order'
        alias_method :orders, :comable_orders
      end
    end

    require 'comable/customer_session'
    require 'comable/cash_register'

    include Comable::CustomerSession

    def logged_in?
      !new_record?
    end

    def not_logged_in?
      !logged_in?
    end

    def add_cart_item(obj)
      case obj
      when Comable::Product
        add_stock_to_cart(obj.stocks.first)
      when Comable::Stock
        add_stock_to_cart(obj)
      when Array
        obj.map { |item| add_cart_item(item) }
      else
        fail
      end
    end

    def remove_cart_item(obj)
      case obj
      when Comable::Stock
        remove_stock_from_cart(obj)
      else
        fail
      end
    end

    def reset_cart
      return super unless self.logged_in?
      cart_items.destroy_all
    end

    def cart_items
      return super unless self.logged_in?
      Comable::CartItem.utusemi(utusemi_values[:flag]).where(Comable::Customer.name.foreign_key => id)
    end

    def cart
      Cart.new(cart_items)
    end

    class Cart < Array
      def price
        cart_item_ids = map(&:id)
        Comable::CartItem.includes(stock: :product).where(id: cart_item_ids).to_a.sum(&:price)
      end
    end

    def preorder(order_params = {})
      Comable::CashRegister.new(customer: self, order_attributes: order_params).build_order
    end

    def order(order_params = {})
      Comable::CashRegister.new(customer: self, order_attributes: order_params).create_order
    end

    private

    def add_stock_to_cart(stock)
      return super unless self.logged_in?

      fail if stock.soldout?

      cart_items = find_cart_items_by(stock)
      if cart_items.any?
        cart_item = cart_items.first
        cart_item.increment!(:quantity)
      else
        cart_items.create
      end
    end

    def remove_stock_from_cart(stock)
      return super unless self.logged_in?

      cart_item = find_cart_items_by(stock).first
      return false unless cart_item

      if cart_item.quantity.pred.nonzero?
        cart_item.decrement!(:quantity)
      else
        cart_item.destroy
      end
    end

    def find_cart_items_by(stock)
      return super unless self.logged_in?

      fail unless stock.is_a?(Comable::Stock.klass)

      Comable::CartItem
        .where(Comable::Customer.name.foreign_key => id)
        .where(Comable::Stock.name.foreign_key => stock.id)
    end
  end
end
