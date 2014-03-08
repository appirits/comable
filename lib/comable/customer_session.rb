module Comable::CustomerSession
  def initialize(*args)
    obj = args.first
    case obj
    when ActionDispatch::Request::Session
      @session = obj
      @session['comable.cart_items'] ||= Marshal.dump([])
      super()
    else
      super
    end
  end

  def reset_cart
    @session.delete('comable.cart_items')
    @session['comable.cart_items'] = Marshal.dump([])
  end

  def cart_items
    Marshal.load(@session['comable.cart_items'])
  end

  private

  def add_product_to_cart(product)
    cart_items = self.cart_items

    selected_cart_items = cart_items.select do |cart_item|
      product_in_cart = cart_item.send(Comable::Engine::config.product_table.to_s.singularize)
      product_in_cart == product
    end

    if selected_cart_items.any?
      cart_item = selected_cart_items.first
      cart_item.quantity = cart_item.quantity.next
    else
      product_id = "#{Comable::Engine::config.product_table.to_s.singularize}_id"
      cart_items << Comable::CartItem.new(product_id => product.id)
    end

    @session['comable.cart_items'] = Marshal.dump(cart_items.map(&:dup))
  end

  def remove_product_from_cart(product)
    cart_items = self.cart_items

    selected_cart_items = cart_items.select do |cart_item|
      product_in_cart = cart_item.send(Comable::Engine::config.product_table.to_s.singularize)
      product_in_cart == product
    end

    return false if selected_cart_items.empty?

    cart_item = selected_cart_items.first
    cart_item.quantity = cart_item.quantity.pred
    cart_items.delete(cart_item) if cart_item.quantity.zero?

    @session['comable.cart_items'] = Marshal.dump(cart_items.map(&:dup))
  end

  def find_cart_items_by(product)
    raise 'not implemented'
  end
end
