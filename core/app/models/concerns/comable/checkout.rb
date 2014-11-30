module Comable
  module Checkout
    extend ActiveSupport::Concern

    included do
      state_machine initial: :cart do
        state :cart
        state :orderer
        state :delivery
        state :payment
        state :shipment
        state :confirm
        state :complete

        event :next_state do
          transition :cart => :orderer
          transition :orderer => :delivery
          transition :delivery => :payment
          transition :payment => :shipment
          transition :shipment => :confirm
          transition :confirm => :complete
        end

        before_transition to: :complete, do: :complete
      end

      with_options if: -> { stated?(:orderer) } do |context|
        context.validates :bill_address, presence: true
      end

      with_options if: -> { stated?(:delivery) } do |context|
        context.validates :ship_address, presence: true
      end
    end

    module ClassMethods
      def state_names
        state_machine.states.keys
      end
    end

    def stated?(target_state)
      target_state_index = self.class.state_names.index(target_state.to_sym)
      current_state_index = self.class.state_names.index(state_name)
      target_state_index < current_state_index
    end
  end
end
