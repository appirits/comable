module Comable
  module Admin
    module OrdersHelper
      def options_of_shipment_badge_for(shipment, state:)
        human_name = shipment.class.state_machine.states[state].human_name
        { class: shipment_badge_class_for(shipment, state: state), title: human_name, data: { toggle: 'tooltip', placement: 'top' } }
      end

      def shipment_badge_class_for(shipment, state:)
        return badge_class_for_state(state) if shipment.state.to_sym == state.to_sym
        can_cancel = shipment.resumed? && state.to_sym == :canceled
        (!can_cancel && shipment.stated?(state)) ? 'comable-badge comable-badge-disable' : 'comable-badge comable-badge-default'
      end

      alias_method :options_of_payment_badge_for, :options_of_shipment_badge_for
      alias_method :payment_badge_class_for, :shipment_badge_class_for

      def badge_class_for_state(state)
        case state.to_sym
        when :pending, :ready
          'comable-badge comable-badge-warning'
        when :completed, :resumed
          'comable-badge comable-badge-success'
        when :canceled
          'comable-badge comable-badge-danger'
        end
      end
    end
  end
end
