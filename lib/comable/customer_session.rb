module Comable
  module CustomerSession
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

    def reset_cart
      cart_items.destroy_all
    end

    private

    def current_guest_token
      @cookies.signed[:guest_token]
    end

    def cart_items
      Comable::CartItem.where(
        Comable::Customer.table_name.singularize.foreign_key => nil,
        :guest_token => current_guest_token
      )
    end

    def add_stock_to_cart(stock)
      found_cart_items = find_cart_items_by(stock)
      if found_cart_items.any?
        found_cart_item = found_cart_items.first
        found_cart_item.quantity = found_cart_item.quantity.next
      else
        cart_item = found_cart_items.create!
        @cookies.permanent.signed[:guest_token] = cart_item.guest_token
      end
    end

    def remove_stock_from_cart(stock)
      cart_item = find_cart_items_by(stock).first
      return false unless cart_item

      if cart_item.quantity.pred.nonzero?
        cart_item.decrement!(:quantity)
      else
        cart_item.destroy!
      end
    end

    def find_cart_items_by(stock)
      cart_items.where(Comable::Stock.table_name.singularize.foreign_key => stock.id)
    end
  end
end
