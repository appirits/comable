module Comable
  module Checkout
    extend ActiveSupport::Concern

    included do
      state_machine initial: :cart do
        state :cart
        state :orderer
        state :delivery
        state :shipment
        state :payment
        state :confirm
        state :completed
        state :canceled
        state :returned
        state :resumed

        event :next_state do
          transition :cart => :orderer, if: :orderer_required?
          transition [:cart, :orderer] => :delivery, if: :delivery_required?
          transition [:cart, :orderer, :delivery] => :shipment, if: :shipment_required?
          transition [:cart, :orderer, :delivery, :shipment] => :payment, if: :payment_required?
          transition all - [:confirm, :completed] => :confirm
          transition :confirm => :completed
        end

        event :cancel do
          transition to: :canceled, from: [:completed, :resumed], if: :allow_cancel?
        end

        event :return do
          transition to: :returned, from: [:completed, :resumed], if: :allow_return?
        end

        event :resume do
          transition to: :resumed, from: :canceled
        end

        before_transition to: :completed, do: :complete!
        before_transition to: :canceled, do: [:payment_cancel!, :restock!]
        before_transition to: :resumed, do: [:payment_resume!, :unstock!]
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

    def orderer_required?
      bill_address.nil? || bill_address.new_record?
    end

    def delivery_required?
      ship_address.nil? || ship_address.new_record?
    end

    def payment_required?
      Comable::PaymentMethod.exists? && payment.nil?
    end

    def shipment_required?
      Comable::ShipmentMethod.activated.exists? && shipment.nil?
    end

    def allow_cancel?
      !shipments.with_state(:completed).exists?
    end

    def allow_return?
      !allow_cancel?
    end
  end
end
