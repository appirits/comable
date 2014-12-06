module Comable
  module PaymentAction
    private

    # orderride OrdersController#order_params
    def order_params
      @order.state?(:payment) ? order_params_for_payment : super
    end

    def order_params_for_payment
      params.fetch(:order, {}).permit(
        :comable_payment_id
      )
    end
  end
end
