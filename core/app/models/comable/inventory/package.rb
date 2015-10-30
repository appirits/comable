module Comable
  module Inventory
    class Package
      attr_accessor :stock_location
      attr_accessor :units

      delegate :empty?, :size, :count, to: :units

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

      def find(unit)
        units.detect { |u| u == unit }
      end

      def add(unit)
        unit = [unit] unless unit.is_a? Array
        units.concat(unit)
      end

      def remove(unit)
        units.delete(unit)
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
