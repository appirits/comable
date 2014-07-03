module Comable
  class CartsController < ApplicationController
    def show
    end

    def add
      product = Comable::Product.find_by(id: params[:product_id])
      return redirect_by_product_not_found unless product

      if product.sku?
        stock = product.stocks.find_by(id: params[:stock_id])
        return redirect_by_product_not_found unless stock
        # TODO: 在庫確認
        current_customer.add_cart_item(stock)
      else
        # TODO: 在庫確認
        current_customer.add_cart_item(product)
      end

      flash[:notice] = I18n.t('comable.carts.add_product')
      redirect_to cart_path
    end

    private

    def redirect_by_product_not_found
      flash[:erorr] = I18n.t('comable.carts.product_not_found')
      redirect_to :back
    end
  end
end
