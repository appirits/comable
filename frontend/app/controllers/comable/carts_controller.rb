module Comable
  class CartsController < Comable::ApplicationController
    rescue_from Comable::NoStock, with: :no_stock

    def show
    end

    def add
      cart_item = Comable::Stock.where(id: params[:stock_id]).first
      cart_item ||= Comable::Product.where(id: params[:product_id]).first
      return redirect_by_product_not_found unless cart_item
      return redirect_by_product_not_found if cart_item.is_a?(Comable::Product) && cart_item.sku?

      current_customer.add_cart_item(cart_item, cart_item_options)

      flash[:notice] = I18n.t('comable.carts.add_product')
      redirect_to cart_path
    end

    def update
      stock = Comable::Stock.where(id: params[:stock_id]).first
      return redirect_by_product_not_found unless stock

      current_customer.reset_cart_item(stock, cart_item_options)

      flash[:notice] = I18n.t('comable.carts.update')
      redirect_to cart_path
    end

    private

    def redirect_by_product_not_found
      flash[:alert] = I18n.t('comable.errors.messages.products_not_found')
      redirect_to :back
    end

    def no_stock
      flash[:alert] = I18n.t('comable.errors.messages.products_soldout')
      redirect_to cart_path
    end

    def cart_item_options
      options = {}
      options.update(quantity: params[:quantity].to_i) if params[:quantity]
      options
    end
  end
end
