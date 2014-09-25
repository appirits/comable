module Comable
  module ShipmentAction
    def shipment
      case request.method_symbol
      when :post
        redirect_to next_order_path
      end
    end

    private

    # orderride OrdersController#order_params
    def order_params
      (action_name.to_sym == :shipment) ? order_params_for_shipment : super
    end

    def shipment_required?
      Comable::ShipmentMethod.activated.exists?
    end

    def order_params_for_shipment
      params.fetch(:order, {}).permit(
        :shipment_method_id
      )
    end
  end
end
