module Comable
  module Admin
    module OrdersHelper
      def shipment_badge_class_for(shipment, state:)
        case shipment.state.to_sym
        when :canceled
          'comable-badge-warning'
        when state.to_sym
          'comable-badge-primary'
        else
          shipment.stated?(state) ? 'comable-badge-disable' : 'comable-badge-default'
        end
      end
    end
  end
end
