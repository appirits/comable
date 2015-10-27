module Comable
  class CartsController < Comable::ApplicationController
    before_filter :set_cart_item, only: [:add, :update, :destroy]
    before_filter :ensure_found_cart_item, only: [:add, :update, :destroy]
    after_filter :reset_shipments, only: [:add, :update, :destroy], if: -> { current_order.shipments.any? }

    def add
      if current_comable_user.add_cart_item(@cart_item, cart_item_options)
        redirect_to comable.cart_path, notice: Comable.t('carts.added')
      else
        flash.now[:alert] = Comable.t('carts.invalid')
        render :show
      end
    end

    def update
      if current_comable_user.reset_cart_item(@cart_item, cart_item_options)
        redirect_to comable.cart_path, notice: Comable.t('carts.updated')
      else
        flash.now[:alert] = Comable.t('carts.invalid')
        render :show
      end
    end

    def destroy
      if current_comable_user.reset_cart_item(@cart_item)
        redirect_to comable.cart_path, notice: Comable.t('carts.updated')
      else
        flash.now[:alert] = Comable.t('carts.invalid')
        render :show
      end
    end

    def checkout
      current_order.next_state if current_order.state?(:cart)
      redirect_to comable.next_order_path(state: :confirm)
    end

    private

    def set_cart_item
      @cart_item = find_cart_item
    end

    def ensure_found_cart_item
      return if @cart_item
      redirect_to :back, alert: Comable.t('errors.messages.products_not_found')
    end

    def find_cart_item
      cart_item = Comable::Stock.find_by(id: params[:stock_id])
      cart_item ||= Comable::Variant.find_by(id: params[:variant_id])
      cart_item ||= Comable::Product.find_by(id: params[:product_id])
      return unless cart_item
      return if cart_item.is_a?(Comable::Product) && cart_item.sku?
      cart_item
    end

    def cart_item_options
      options = {}
      options.update(quantity: params[:quantity].to_i) if params[:quantity]
      options
    end

    def reset_shipments
      current_order.reset_shipments
      current_order.update!(state: 'cart')
    end
  end
end
