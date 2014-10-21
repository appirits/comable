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

      options = {}
      options.update(quantity: params[:quantity].to_i) if params[:quantity]

      current_customer.add_cart_item(stock || product, options)

      flash[:notice] = I18n.t('comable.carts.add_product')
      redirect_to cart_path
    end

    def update
      stock = Comable::Stock.where(id: params[:stock_id]).first
      return redirect_by_product_not_found unless stock

      options = {}
      options.update(quantity: params[:quantity].to_i) if params[:quantity]

      current_customer.reset_cart_item(stock, options)

      flash[:notice] = I18n.t('comable.carts.update')
      redirect_to cart_path
    end

    private

    def redirect_by_product_not_found
      flash[:error] = I18n.t('comable.errors.messages.products_not_found')
      redirect_to :back
    end

    def no_stock
      flash[:error] = I18n.t('comable.errors.messages.products_soldout')
      redirect_to cart_path
    end
  end
end
