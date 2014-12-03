module Comable
  class OrdersController < Comable::ApplicationController
    prepend Comable::ShipmentAction
    prepend Comable::PaymentAction
    include Comable::PermittedAttributes

    helper_method :next_order_path

    # TODO: Change the method name to load_order_with_params
    before_filter :load_order
    before_filter :ensure_cart_not_empty
    before_filter :ensure_saleable_stocks
    # TODO: Remove
    after_filter :save_order, except: :create

    def new
    end

    def edit
      if @order.state == params[:state]
        render @order.state_name
      else
        redirect_to next_order_path
      end
    end

    def update
      if @order.next_state
        redirect_to next_order_path
      else
        render @order.state
      end
    end

    def create
      if @order.next_state
        flash[:notice] = I18n.t('comable.orders.success')
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

    def next_order_path
      return comable.next_order_path(state: :orderer) if @order.state?(:cart)
      comable.next_order_path(state: @order.state)
    end

    def agreement_required?
      @order.customer.nil?
    end

    def orderer_required?
      @order.bill_address.nil?
    end

    def delivery_required?
      @order.ship_address.nil?
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

    def save_order
      @order.save
    end

    def order_params
      return unless params[:order]
      case @order.state_name
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
