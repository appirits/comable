module Comable
  class CartsController < ApplicationController
    def show
    end

    def add
      product = Product.find(params[:product_id])
      if product
        current_customer.add_cart_item(product)
        flash[:notice] = I18n.t('comable.carts.add_product')
      end
      redirect_to cart_path
    end
  end
end
