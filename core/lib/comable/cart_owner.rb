module Comable
  module CartOwner
    def add_cart_item(obj, quantity: 1)
      process_cart_item(obj) do |stock|
        add_stock_to_cart(stock, quantity)
      end
    end

    def remove_cart_item(obj, quantity: -1)
      add_cart_item(obj, quantity: quantity)
    end

    def reset_cart_item(obj, quantity: 0)
      process_cart_item(obj) do |stock|
        reset_stock_from_cart(stock, quantity)
      end
    end

    def cart_items
      fail 'You should implement cart_items method.'
    end

    def cart
      Cart.new(cart_items)
    end

    class Cart < Array
      def price
        sum(&:current_subtotal_price)
      end
    end

    private

    def process_cart_item(obj)
      case obj
      when Comable::Product
        yield obj.stocks.first
      when Comable::Stock
        yield obj
      when Array
        obj.map { |item| yield item }
      else
        fail
      end
    end

    def add_stock_to_cart(stock, quantity)
      cart_items = find_cart_items_by(stock)
      if cart_items.any?
        cart_item = cart_items.first
        fail Comable::NoStock if stock.soldout?(quantity: quantity + cart_item.quantity)
        cart_item.quantity += quantity
        (cart_item.quantity > 0) ? cart_item.save : cart_item.destroy
      else
        fail Comable::NoStock if stock.soldout?(quantity: quantity)
        cart_items.create(quantity: quantity)
      end
    end

    def reset_stock_from_cart(stock, quantity)
      fail Comable::NoStock if stock.soldout?(quantity: quantity)

      cart_items = find_cart_items_by(stock)
      if quantity > 0
        return add_stock_to_cart(stock, quantity) if cart_items.empty?
        cart_item = cart_items.first
        cart_item.quantity = quantity
        cart_item.save
      else
        return false if cart_items.empty?
        cart_items.first.destroy
      end
    end

    def find_cart_items_by(stock)
      # TODO: Refactoring
      fail unless stock.is_a?(Comable::Stock)
      cart_items.where(Comable::Stock.table_name.singularize.foreign_key => stock.id)
    end
  end
end
