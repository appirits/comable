module Comable
  class Payment < ActiveRecord::Base
    include Comable::Ransackable

    belongs_to :order, class_name: Comable::Order.name, inverse_of: :payment
    belongs_to :payment_method, class_name: Comable::PaymentMethod.name

    before_validation :copy_attributes_from_payment_method, unless: :order_completed?

    validates :order, presence: true
    validates :payment_method, presence: true
    validates :fee, presence: true, numericality: { greater_than_or_equal_to: 0 }

    delegate :name, to: :payment_method
    delegate :payment_provider, to: :payment_method
    delegate :authorize!, :complete!, :cancel!, :resume!, to: :payment_provider, prefix: :provider

    ransack_options ransackable_attributes: { except: [:order_id, :payment_method_id] }

    # The #state attribute assigns the following values:
    #
    # pending   when Order is not able to pay (default)
    # ready     when Order is able to pay
    # completed when Order is already paid
    # canceled  when Order is canceled
    # resumed   when Order is resumed from the "canceled" state
    state_machine initial: :pending do
      state :pending
      state :ready
      state :completed
      state :canceled
      state :resumed

      event :next_state do
        transition :pending => :ready
        transition :ready => :completed
      end

      event :cancel do
        transition [:completed, :resumed] => :canceled
      end

      event :resume do
        transition :canceled => :resumed
      end

      after_transition to: :ready, do: :next_state!
      before_transition to: :ready, do: -> (s) { s.provider_authorize! }
      before_transition to: :completed, do: -> (s) { s.complete! }
      before_transition to: :canceled, do: -> (s) { s.provider_cancel! }
      before_transition to: :resumed, do: -> (s) { s.provider_resume! }
    end

    class << self
      def state_names
        state_machine.states.keys
      end
    end

    def stated?(target_state)
      target_state_index = self.class.state_names.index(target_state.to_sym)
      current_state_index = self.class.state_names.index(state_name)
      target_state_index < current_state_index
    end

    def completed?
      completed_at?
    end

    def complete!
      provider_complete!
      touch :completed_at
    end

    private

    def order_completed?
      order.completed?
    end

    def copy_attributes_from_payment_method
      self.attributes = {
        fee: payment_method.fee
      }
    end
  end
end
