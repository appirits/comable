module Comable
  class CartsController < ApplicationController
    def show
    end

    def add
      product = Comable::Product.where(id: params[:product_id]).first
      return redirect_by_product_not_found unless product

      if product.sku?
        stock = product.stocks.where(id: params[:stock_id]).first
        return redirect_by_product_not_found unless stock
      end

      # TODO: 在庫確認
      current_customer.add_cart_item(stock || product)

      flash[:notice] = I18n.t('comable.carts.add_product')
      redirect_to cart_path
    end

    private

    def redirect_by_product_not_found
      flash[:error] = I18n.t('comable.carts.product_not_found')
      redirect_to :back
    end
  end
end
