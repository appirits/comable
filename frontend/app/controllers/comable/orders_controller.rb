module Comable
  class OrdersController < Comable::ApplicationController
    # TODO: Change the method name to load_order_with_params
    before_filter :load_order
    before_filter :ensure_cart_not_empty
    before_filter :ensure_saleable_stocks
    before_filter :ensure_correct_flow, only: :create

    prepend Comable::SigninAction
    prepend Comable::ShipmentAction
    prepend Comable::PaymentAction
    include Comable::PermittedAttributes

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
      @order.next_state!

      flash.now[:notice] = Comable.t('orders.success')
      send_order_complete_mail
    rescue ActiveRecord::RecordInvalid, Comable::PaymentError
      flash[:alert] = @order.errors.full_messages.join
      redirect_to next_order_path
    end

    private

    def send_order_complete_mail
      return unless current_store.can_send_mail?
      if Rails.version =~ /^4.2./
        Comable::OrderMailer.complete(@order).deliver_now
      else
        Comable::OrderMailer.complete(@order).deliver
      end
    end

    def ensure_cart_not_empty
      return if current_comable_user.cart.any?
      flash[:alert] = Comable.t('carts.empty')
      redirect_to comable.cart_path
    end

    def ensure_saleable_stocks
      return if current_order.stocked_items.empty?
      flash[:alert] = Comable.t('errors.messages.out_of_stocks')
      redirect_to comable.cart_path
    end

    def ensure_correct_flow
      return if @order.state?(:confirm)
      redirect_to next_order_path
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
