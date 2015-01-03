module Comable
  class OrdersController < Comable::ApplicationController
    prepend Comable::ShipmentAction
    prepend Comable::PaymentAction
    include Comable::PermittedAttributes

    # TODO: Change the method name to load_order_with_params
    before_filter :load_order
    before_filter :ensure_cart_not_empty
    before_filter :ensure_saleable_stocks

    def new
    end

    def edit
      if @order.state?(params[:state]) || @order.stated?(params[:state])
        render params[:state]
      else
        redirect_to next_order_path
      end
    end

    def update
      if @order.stated?(params[:state]) ? @order.save : @order.next_state
        redirect_to next_order_path
      else
        render @order.state
      end
    end

    def create
      if @order.state?(:confirm) && @order.next_state
        flash.now[:notice] = I18n.t('comable.orders.success')
        send_order_complete_mail
      else
        flash[:alert] = I18n.t('comable.orders.failure')
        redirect_to next_order_path
      end
    end

    private

    def send_order_complete_mail
      Comable::OrderMailer.complete(@order).deliver if current_store.email_activate?
    end

    # TODO: Remove
    def agreement_required?
      @order.customer.nil?
    end

    def ensure_cart_not_empty
      return if current_customer.cart.any?
      flash[:alert] = I18n.t('comable.carts.empty')
      redirect_to comable.cart_path
    end

    def ensure_saleable_stocks
      return if current_order.soldout_stocks.empty?
      flash[:alert] = I18n.t('comable.errors.messages.products_soldout')
      redirect_to comable.cart_path
    end

    def load_order
      @order = current_order
      @order.attributes = order_params if order_params
    end

    def order_params
      return unless params[:order]
      return unless params[:state]
      case params[:state].to_sym
      when :orderer
        order_params_for_orderer
      when :delivery
        order_params_for_delivery
      end
    end

    def order_params_for_orderer
      params.require(:order).permit(
        :email,
        bill_address_attributes: permitted_address_attributes
      )
    end

    def order_params_for_delivery
      params.require(:order).permit(
        ship_address_attributes: permitted_address_attributes
      )
    end
  end
end
