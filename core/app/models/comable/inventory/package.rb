module Comable
  module Inventory
    class Package
      attr_accessor :stock_location
      attr_accessor :units

      delegate :empty?, to: :units

      def initialize(stock_location)
        @stock_location = stock_location
        @units = []
      end

      def initialize_copy(package)
        super
        self.units = package.units.clone
      end

      def to_shipment
        shipment = Comable::Shipment.new(stock_location: stock_location)
        shipment.shipment_items = build_shipment_items(shipment)
        shipment
      end

      def find(item)
        units.detect do |unit|
          unit == item
        end
      end

      def add(item)
        item = [item] unless item.is_a? Array
        units.concat(item)
      end

      def remove(item)
        units.delete(item)
      end

      private

      def build_shipment_items(shipment)
        units.map do |unit|
          unit.to_shipment_item(shipment)
        end
      end
    end
  end
end
