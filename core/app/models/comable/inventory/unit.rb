module Comable
  module Inventory
    class Unit
      attr_accessor :variant

      def initialize(variant)
        @variant = variant
      end

      def to_shipment_item(shipment)
        stock = find_stock_item(shipment)
        Comable::ShipmentItem.new(stock: stock)
      end

      private

      def find_stock_item(shipment)
        shipment.stock_location.find_stock_item(variant)
      end
    end
  end
end
