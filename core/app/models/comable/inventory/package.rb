module Comable
  module Inventory
    class Package
      attr_accessor :stock_location
      attr_accessor :shipment_items

      delegate :empty?, to: :shipment_items

      def initialize(stock_location)
        @stock_location = stock_location
        @shipment_items = []
      end

      def initialize_copy(package)
        super
        self.shipment_items = package.shipment_items.clone
      end

      def to_shipment
        Comable::Shipment.new(stock_location: stock_location, shipment_items: shipment_items)
      end

      def find(item)
        shipment_items.detect do |shipment_item|
          shipment_item == item
        end
      end

      def add(item)
        item = [item] unless item.is_a? Array
        shipment_items.concat(item)
      end

      def remove(item)
        shipment_items.delete(item)
      end
    end
  end
end
