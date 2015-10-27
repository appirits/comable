module Comable
  class ShipmentItem < ActiveRecord::Base
    belongs_to :shipment, class_name: Comable::Shipment.name
    belongs_to :stock, class_name: Comable::Stock.name

    validates :shipment, presence: true
    validates :stock, presence: true
  end
end
