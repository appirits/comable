module Comable
  class OrdersController < Comable::ApplicationController
    prepend Comable::ShipmentAction
    prepend Comable::PaymentAction

    before_filter :load_order
    before_filter :verify
    before_filter :redirect_for_logged_in_customer, only: [:new, :orderer]
    after_filter :save_order, except: :create

    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from Comable::InvalidOrder, with: :order_invalid

    def new
    end

    def orderer
      case request.method_symbol
      when :post
        redirect_to comable.delivery_order_path
      end
    end

    def delivery
      case request.method_symbol
      when :post
        redirect_to next_order_path
      end
    end

    def confirm
    end

    def create
      order = current_customer.order
      if order.complete?
        Comable::OrderMailer.complete(order).deliver if current_store.email_activate?
        flash[:notice] = I18n.t('comable.orders.success')
      else
        flash[:alert] = I18n.t('comable.orders.failure')
        redirect_to comable.confirm_order_path
      end
    end

    private

    def next_order_path(target_action_name = nil)
      case (target_action_name || action_name).to_sym
      when :delivery
        shipment_required? ? comable.shipment_order_path : next_order_path(:shipment)
      when :shipment
        payment_required? ? comable.payment_order_path : next_order_path(:payment)
      else
        comable.confirm_order_path
      end
    end

    def verify
      return if current_customer.cart.any?
      flash[:alert] = I18n.t('comable.carts.empty')
      redirect_to comable.cart_path
    end

    def load_order
      @order = current_customer.preorder(order_params || {})
    end

    def save_order
      @order.save
    end

    def order_params
      return unless params[:order]
      case action_name.to_sym
      when :orderer
        order_params_for_orderer
      when :delivery
        order_params_for_delivery
      end
    end

    def order_params_for_orderer
      params.require(:order).permit(
        :family_name,
        :first_name,
        :email
      )
    end

    def order_params_for_delivery
      params.require(:order).permit(
        order_deliveries_attributes: [
          :id,
          :family_name,
          :first_name
        ]
      )
    end

    def redirect_for_logged_in_customer
      return redirect_to delivery_order_path if current_customer.logged_in?
    end

    def record_invalid
      flash[:alert] = I18n.t('comable.orders.failure')
      redirect_to comable.cart_path
    end

    def order_invalid(exception)
      flash[:alert] = exception.message
      redirect_to comable.cart_path
    end
  end
end
