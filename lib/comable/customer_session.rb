module Comable::CustomerSession
  def initialize(*args)
    obj = args.first
    case obj
    when session_class
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

    save_cart_to_session
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

  def session_class
    case Rails.version.split('.').first.to_i
    when 4
      ActionDispatch::Request::Session
    when 3
      Rack::Session::Abstract::SessionHash
    end
  end
end
