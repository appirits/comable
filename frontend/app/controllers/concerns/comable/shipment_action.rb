module Comable
  module ShipmentAction
    private

    # orderride OrdersController#order_params
    def order_params
      return super unless params[:state] == 'shipment'
      order_params_for_shipment
    end

    def order_params_for_shipment
      params.fetch(:order, {}).permit(
        shipments_attributes: [:shipment_method_id]
      )
    end
  end
end
