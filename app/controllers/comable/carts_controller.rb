module Comable
  class CartsController < ApplicationController
    def show
    end

    def add
      product = Product.find(params[:product_id])
      @customer.add_cart_item(product) if product
      redirect_to cart_path
    end
  end
end
