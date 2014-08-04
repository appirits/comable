module Comable
  class Customer < ActiveRecord::Base
    include Decoratable

    has_many :comable_orders, class_name: Comable::Order.name, foreign_key: table_name.singularize.foreign_key
    alias_method :orders, :comable_orders

    def initialize(*args)
      obj = args.first
      case obj.class.name
      when /Cookies/
        @cookies = obj
        super()
      else
        super
      end
    end

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
      cart_items.destroy_all
    end

    def cart_items
      Comable::CartItem.where(
        Comable::Customer.table_name.singularize.foreign_key => id,
        :guest_token => current_guest_token
      )
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

    def current_guest_token
      return if logged_in?
      @cookies.signed[:guest_token]
    end

    def add_stock_to_cart(stock)
      fail I18n.t('comable.carts.product_not_stocked') if stock.soldout?

      cart_items = find_cart_items_by(stock)
      if cart_items.any?
        cart_item = cart_items.first
        cart_item.increment!(:quantity)
      else
        cart_item = cart_items.create
        @cookies.permanent.signed[:guest_token] = cart_item.guest_token if not_logged_in?
      end
    end

    def remove_stock_from_cart(stock)
      cart_item = find_cart_items_by(stock).first
      return false unless cart_item

      if cart_item.quantity.pred.nonzero?
        cart_item.decrement!(:quantity)
      else
        cart_item.destroy
      end
    end

    def find_cart_items_by(stock)
      fail I18n.t('comable.carts.product_not_found') unless stock.is_a?(Comable::Stock)
      cart_items.where(Comable::Stock.table_name.singularize.foreign_key => stock.id)
    end
  end
end
