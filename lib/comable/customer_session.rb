module Comable
  module CustomerSession
    attr_reader :cart_items

    def initialize(*args)
      obj = args.first
      case obj.class.name
      when /Session/
        @session = obj
        @cart_items = load_cart_from_session
        super()
      else
        super
      end
    end

    def reset_cart
      @cart_items = []
      reset_session
    end

    private

    def add_stock_to_cart(stock)
      found_cart_items = find_cart_items_by(stock)
      if found_cart_items.any?
        found_cart_item = found_cart_items.first
        found_cart_item.quantity = found_cart_item.quantity.next
      else
        @cart_items << Comable::CartItem.comable(comable_values[:flag]).new(Comable::Stock.foreign_key => stock.id)
      end
      save_cart_to_session
    end

    def remove_stock_from_cart(stock)
      found_cart_items = find_cart_items_by(stock)
      return false if found_cart_items.empty?

      found_cart_item = found_cart_items.first
      found_cart_item.quantity = found_cart_item.quantity.pred
      cart_items.delete(found_cart_item) if found_cart_item.quantity.zero?

      save_cart_to_session
    end

    def find_cart_items_by(stock)
      cart_items.select do |cart_item|
        stock_in_cart = cart_item.stock
        stock_in_cart == stock
      end
    end

    def reset_session
      @session.delete('comable.cart')
    end

    def save_cart_to_session
      cart_items_dump = Marshal.dump(@cart_items.map(&:dup))
      cart_items_dump_compressed = Zlib::Deflate.deflate(cart_items_dump)
      @session['comable.cart'] = cart_items_dump_compressed
    end

    def load_cart_from_session
      cart_items_dump_compressed = @session['comable.cart']
      if cart_items_dump_compressed
        cart_items_dump = Zlib::Inflate.inflate(cart_items_dump_compressed)
        @cart_items = Marshal.load(cart_items_dump)
      else
        @cart_items = []
      end
    end
  end
end
