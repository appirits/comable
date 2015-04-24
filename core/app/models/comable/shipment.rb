module Comable
  class Shipment < ActiveRecord::Base
    belongs_to :order, class_name: Comable::Order.name, inverse_of: :shipment
    belongs_to :shipment_method, class_name: Comable::ShipmentMethod.name

    validates :order, presence: true
    validates :shipment_method, presence: true
    validates :name, presence: true, length: { maximum: 255 }
    validates :fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :tracking_number, length: { maximum: 255 }

    # The #state attribute assigns the following values:
    #
    # pending   when Order is not able to ship (default)
    # ready     when Order is able to ship
    # complete  when Order is already shipped
    # canceled  when Order is canceled
    # resumed   when Order is resumed from the "canceled" state
    state_machine initial: :pending do
      state :pending
      state :ready
      state :complete
      state :canceled
      state :resume
    end
  end
end
