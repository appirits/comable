module Comable
  class OrdersController < ApplicationController
    before_filter :load_order
    before_filter :verify
    before_filter :redirect_for_logged_in_customer, only: [ :new, :orderer ]
    after_filter :save_order, except: :create

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
        @order.order_deliveries.build if @order.order_deliveries.size.zero?
      end
    end

    def confirm
      @order = @customer.preorder(build_order_nested_attributes)
    end

    def create
      @order = @customer.order(build_order_nested_attributes)
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
      if @customer.cart.empty?
        flash[:alert] = I18n.t('comable.carts.empty')
        redirect_to comable.cart_path
      end
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
        comable_order_deliveries_attributes: build_order_delivery_nested_attributes
      )
    end

    def build_order_delivery_nested_attributes
      @order.order_deliveries.map do |order_delivery|
        order_delivery.attributes.merge(
          comable_order_details_attributes: order_delivery.order_details.map(&:attributes)
        )
      end
    end

    def order_params
      return unless params[:order]
      case action_name.to_sym
      when :orderer
        params.require(:order).permit(
          :family_name,
          :first_name
        )
      when :delivery
        params.require(:order).permit(
          comable_order_deliveries_attributes: [
            :family_name,
            :first_name
          ]
        )
      end
    end

    def redirect_for_logged_in_customer
      return redirect_to delivery_order_path if @customer.logged_in?
    end
  end
end
