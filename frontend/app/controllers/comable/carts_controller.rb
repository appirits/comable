module Comable
  class CartsController < ApplicationController
    rescue_from Comable::NoStock, with: :no_stock

    def show
    end

    def add
      product = Comable::Product.where(id: params[:product_id]).first
      return redirect_by_product_not_found unless product

      if product.sku?
        stock = product.stocks.where(id: params[:stock_id]).first
        return redirect_by_product_not_found unless stock
      end

      current_customer.add_cart_item(stock || product, quantity: params[:quantity].to_i)

      flash[:notice] = I18n.t('comable.carts.add_product')
      redirect_to cart_path
    end

    def update
      stock = Comable::Stock.where(id: params[:stock_id]).first
      return redirect_by_product_not_found unless stock

      current_customer.reset_cart_item(stock, quantity: params[:quantity].to_i)

      flash[:notice] = I18n.t('comable.carts.update')
      redirect_to cart_path
    end

    private

    def redirect_by_product_not_found
      flash[:error] = I18n.t('comable.carts.product_not_found')
      redirect_to :back
    end

    def no_stock
      flash[:error] = I18n.t('comable.carts.product_not_stocked')
      redirect_to cart_path
    end
  end
end
