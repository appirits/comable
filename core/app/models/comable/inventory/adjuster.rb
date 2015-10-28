module Comable
  module Inventory
    class Adjuster
      attr_accessor :packages
      attr_accessor :shipment_items

      def initialize(packages, shipment_items)
        @packages = packages.map(&:clone)
        @shipment_items = shipment_items
      end

      def adjusted_packages
        remove_duplicated_items
        packages
      end

      private

      def remove_duplicated_items
        shipment_items.each do |shipment_item|
          remove_duplicated(shipment_item)
        end
      end

      def remove_duplicated(shipment_item)
        duplicated = false

        packages.each do |package|
          next unless package.find(shipment_item)

          if duplicated
            package.remove(shipment_item)
          else
            duplicated = true
          end
        end
      end
    end
  end
end
