module Comable
  class OrdersController < ApplicationController
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
        redirect_to comable.confirm_order_path
      when :get
        @order.order_deliveries.build if @order.order_deliveries.empty?
      end
    end

    def confirm
      @order.precomplete
    end

    def create
      if @order.complete
        flash[:notice] = I18n.t('comable.orders.success')
      else
        flash[:alert] = I18n.t('comable.orders.failure')
        redirect_to comable.confirm_order_path
      end
    end

    private

    def verify
      return if current_customer.cart.any?
      flash[:alert] = I18n.t('comable.carts.empty')
      redirect_to comable.cart_path
    end

    def load_order
      @order = current_customer.incomplete_order
      @order.attributes = order_params if order_params
      @order
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
        :first_name
      )
    end

    def order_params_for_delivery
      params.require(:order).permit(
        order_deliveries_attributes: [
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
