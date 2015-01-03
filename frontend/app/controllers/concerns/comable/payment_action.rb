module Comable
  module PaymentAction
    private

    # orderride OrdersController#order_params
    def order_params
      return super unless params[:state] == 'payment'
      order_params_for_payment
    end

    def order_params_for_payment
      params.fetch(:order, {}).permit(
        :payment_method_id
      )
    end
  end
end
