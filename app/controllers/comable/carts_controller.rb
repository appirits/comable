module Comable
  class CartsController < ApplicationController
    before_filter :load

    def show
    end

    def add
      product = Product.find(params[:product_id])
      @customer.add_cart_item(product) if product
      redirect_to cart_path
    end

    private

    def load
      load_customer
      load_cart
    end

    def load_customer
      @customer = Customer.new(session)
    end

    def load_cart
      @cart = @customer.cart
    end
  end
end
