module Comable
  module Admin
    module OrdersHelper
      def options_of_shipment_badge_for(shipment, state:)
        human_name = shipment.class.state_machine.states[state].human_name
        { class: shipment_badge_class_for(shipment, state: state), title: human_name, data: { toggle: 'tooltip', placement: 'top' } }
      end

      def shipment_badge_class_for(shipment, state:)
        case state.to_sym
        when shipment.state.to_sym
          shipment.state?(:canceled) ? 'comable-badge comable-badge-warning' : 'comable-badge comable-badge-primary'
        else
          can_cancel = shipment.state?(:resumed) && state.to_sym == :canceled
          (!can_cancel && shipment.stated?(state)) ? 'comable-badge comable-badge-disable' : 'comable-badge comable-badge-default'
        end
      end
    end
  end
end
