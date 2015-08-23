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

    def move_cart_item(cart_item)
      add_cart_item(cart_item.stock, quantity: cart_item.quantity) && cart_item.destroy
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

      def count
        sum(&:quantity)
      end

      alias_method :size, :count

      # TODO: Refactoring
      def errors
        ActiveModel::Errors.new(self).tap do |obj|
          map(&:errors).map(&:full_messages).flatten.each do |full_message|
            obj[:base] << full_message
          end
        end
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
      cart_item = find_cart_item_by(stock)
      if cart_item
        cart_item.quantity += quantity
        (cart_item.quantity > 0) ? cart_item.save : cart_item.destroy
      else
        cart_items.build(variant: stock.variant, quantity: quantity).save
      end
    end

    def reset_stock_from_cart(stock, quantity)
      cart_item = find_cart_item_by(stock)
      if quantity > 0
        return add_stock_to_cart(stock, quantity) unless cart_item
        cart_item.update_attributes(quantity: quantity)
      else
        return false unless cart_item
        cart_items.destroy(cart_item)
      end
    end

    def find_cart_item_by(stock)
      # TODO: Refactoring
      fail unless stock.is_a?(Comable::Stock)
      cart_items.find { |cart_item| cart_item.stock.id == stock.id }
    end
  end
end
