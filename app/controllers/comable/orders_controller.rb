module Comable
  class OrdersController < ApplicationController
    before_filter :load
    before_filter :verify
    after_filter :save, except: :create

    def new
    end

    def orderer
      case request.method_symbol
      when :post
        redirect_to action: :delivery
      end
    end

    def delivery
      case request.method_symbol
      when :post
        redirect_to action: :confirm
      when :get
        @order.order_deliveries.build if @order.order_deliveries.size.zero?
      end
    end

    def confirm
      @order = @customer.preorder(build_order_nested_attributes)
    end

    def create
      @order = @customer.order(build_order_nested_attributes)
      reset_session
    end

    private

    def reset_session
      session.delete('comable.order')
    end

    def load
      load_customer
      load_order
    end

    def verify
      if @customer.cart.empty?
        flash[:error] = 'cart is empty'
        redirect_to comable.cart_path
      end
    end

    def load_customer
      @customer = Customer.new(session)
    end

    def load_order
      @customer = Customer.new(session)
      order_attributes = JSON.parse(session['comable.order'] || '{}')
      order_attributes.update(order_params) if order_params
      @order = Order.new(order_attributes)
    end

    def save
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
  end
end
