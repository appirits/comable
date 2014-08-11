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
      @order = current_customer.preorder(build_order_nested_attributes)
    end

    def create
      @order = current_customer.order(build_order_nested_attributes)
      if @order.valid?
        flash[:notice] = I18n.t('comable.orders.success')
        reset_session
      else
        flash[:alert] = I18n.t('comable.orders.failure')
        redirect_to comable.confirm_order_path
      end
    end

    private

    def reset_session
      session.delete('comable.order')
    end

    def verify
      return if current_customer.cart.any?
      flash[:alert] = I18n.t('comable.carts.empty')
      redirect_to comable.cart_path
    end

    def load_order
      order_attributes = JSON.parse(session['comable.order'] || '{}')
      order_attributes.update(order_params) if order_params
      @order = Comable::Order.new(order_attributes)
    end

    def save_order
      session['comable.order'] = build_order_nested_attributes.to_json
    end

    def build_order_nested_attributes
      @order.attributes.merge(
        order_deliveries_attributes: build_order_delivery_nested_attributes
      )
    end

    def build_order_delivery_nested_attributes
      @order.order_deliveries.map(&:attributes)
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
