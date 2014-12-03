module Comable
  module PaymentAction
    def payment
      case request.method_symbol
      when :post
        redirect_to next_order_path
      end
    end

    private

    # orderride OrdersController#order_params
    def order_params
      (action_name.to_sym == :payment) ? order_params_for_payment : super
    end

    def order_params_for_payment
      params.fetch(:order, {}).permit(
        :comable_payment_id
      )
    end
  end
end
