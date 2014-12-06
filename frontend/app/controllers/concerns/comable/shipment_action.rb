module Comable
  module ShipmentAction
    private

    # orderride OrdersController#order_params
    def order_params
      @order.state?(:shipment) ? order_params_for_shipment : super
    end

    def order_params_for_shipment
      params.fetch(:order, {}).permit(
        :shipment_method_id
      )
    end
  end
end
