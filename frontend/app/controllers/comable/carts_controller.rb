module Comable
  class CartsController < Comable::ApplicationController
    before_filter :set_cart_item, only: [:add, :update]
    before_filter :ensure_found_cart_item, only: [:add, :update]

    def add
      if current_customer.add_cart_item(@cart_item, cart_item_options)
        flash[:notice] = I18n.t('comable.carts.add_product')
        redirect_to comable.cart_path
      else
        flash.now[:alert] = I18n.t('comable.carts.invalid')
        render :show
      end
    end

    def update
      if current_customer.reset_cart_item(@cart_item, cart_item_options)
        flash[:notice] = I18n.t('comable.carts.update')
        redirect_to comable.cart_path
      else
        flash.now[:alert] = I18n.t('comable.carts.invalid')
        render :show
      end
    end

    private

    def set_cart_item
      @cart_item = find_cart_item
    end

    def ensure_found_cart_item
      return if @cart_item
      flash[:alert] = I18n.t('comable.errors.messages.products_not_found')
      redirect_to :back
    end

    def find_cart_item
      cart_item = Comable::Stock.where(id: params[:stock_id]).first
      cart_item ||= Comable::Product.where(id: params[:product_id]).first
      return unless cart_item
      return if cart_item.is_a?(Comable::Product) && cart_item.sku?
      cart_item
    end

    def cart_item_options
      options = {}
      options.update(quantity: params[:quantity].to_i) if params[:quantity]
      options
    end
  end
end
