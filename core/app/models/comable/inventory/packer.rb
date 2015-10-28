module Comable
  module Inventory
    class Packer
      attr_accessor :stock_location
      attr_accessor :shipment_items

      def initialize(stock_location, shipment_items)
        @stock_location = stock_location
        @shipment_items = shipment_items
      end

      def package
        package = Package.new(stock_location)

        shipment_items.group_by(&:variant).each do |variant, variant_shipment_items|
          stock = stock_location.find_stock_item(variant)
          next unless stock
          package.add variant_shipment_items.take(stock.quantity) if stock.stocked?
        end

        package
      end
    end
  end
end
