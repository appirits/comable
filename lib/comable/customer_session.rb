module Comable::CustomerSession
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

  def cart_items
    @cart_items
  end

  private

  def add_product_to_cart(product)
    cart_items = self.cart_items
    stock = product.stocks.first

    selected_cart_items = cart_items.select do |cart_item|
      stock_in_cart = cart_item.send(Comable::Stock.model_name.singular)
      stock_in_cart == stock
    end

    if selected_cart_items.any?
      cart_item = selected_cart_items.first
      cart_item.quantity = cart_item.quantity.next
    else
      stock_id = "#{Comable::Stock.model_name.singular}_id"
      cart_items << Comable::CartItem.new(stock_id => stock.id)
    end

    save_cart_to_session
  end

  def remove_product_from_cart(product)
    cart_items = self.cart_items
    stock = product.stocks.first

    selected_cart_items = cart_items.select do |cart_item|
      stock_in_cart = cart_item.send(Comable::Stock.model_name.singular)
      stock_in_cart == stock
    end

    return false if selected_cart_items.empty?

    cart_item = selected_cart_items.first
    cart_item.quantity = cart_item.quantity.pred
    cart_items.delete(cart_item) if cart_item.quantity.zero?

    save_cart_to_session
  end

  def find_cart_items_by(product)
    raise 'not implemented'
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
