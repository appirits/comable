module Comable
  class Shipment < ActiveRecord::Base
    include Comable::Ransackable

    belongs_to :order, class_name: Comable::Order.name, inverse_of: :shipments
    belongs_to :shipment_method, class_name: Comable::ShipmentMethod.name
    belongs_to :stock_location, class_name: Comable::StockLocation.name
    has_many :shipment_items, class_name: Comable::ShipmentItem.name

    before_validation :copy_attributes_from_shipment_method, unless: :order_completed?

    validates :order, presence: true
    validates :shipment_method, presence: true, if: -> { stated?(:pending) && Comable::ShipmentMethod.activated.exists? }
    validates :fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :tracking_number, length: { maximum: 255 }

    ransack_options ransackable_attributes: { except: [:order_id, :shipment_method_id] }

    # The #state attribute assigns the following values:
    #
    # pending   when Order is not able to ship (default)
    # ready     when Order is able to ship
    # completed when Order is already shipped
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

      event :ship do
        transition :ready => :completed
      end

      event :cancel do
        transition [:completed, :resumed] => :canceled
      end

      event :resume do
        transition :canceled => :resumed
      end

      before_transition to: :ready, do: -> (s) { s.ready! }
      before_transition to: :completed, do: -> (s) { s.complete! }
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

    def ready!
      shipment_items.each(&:ready!)
    end

    def complete!
      touch :completed_at
    end

    def restock!
      shipment_items.each(&:restock!)
    end

    def unstock!
      shipment_items.each(&:unstock!)
    end

    def can_ship?
      ready? && order.paid? && order.completed?
    end

    def name
      if shipment_method
        shipment_method.name
      else
        # TODO: I18n
        'Normal shipment'
      end
    end

    private

    def order_completed?
      order.completed?
    end

    def copy_attributes_from_shipment_method
      self.attributes = {
        fee: shipment_method.try(:fee) || 0
      }
    end
  end
end
