module Comable
  module Inventory
    class Coordinator
      attr_accessor :order
      attr_accessor :shipment_items

      def initialize(order)
        @order = order
        @shipment_items = build_shipment_items
      end

      def shipments
        packages.map(&:to_shipment)
      end

      private

      def packages
        packages = build_packages
        packages = adjust_packages(packages)
        packages = compact_packages(packages)
      end

      def build_packages
        Comable::StockLocation.active.map do |stock_location|
          next unless items_exists_in? stock_location
          build_packer(stock_location).package
        end
      end

      def adjust_packages(packages)
        Adjuster.new(packages, shipment_items).adjusted_packages
      end

      def compact_packages(packages)
        packages.reject(&:empty?)
      end

      def items_exists_in?(stock_location)
        stock_location.stocks.where(variant: shipment_items.map(&:variant).uniq).exists?
      end

      def build_packer(stock_location)
        Packer.new(stock_location, shipment_items)
      end

      def build_shipment_items
        order.order_items.map do |order_item|
          order_item.quantity.times.map do
            Comable::ShipmentItem.new(variant: order_item.variant)
          end
        end.flatten
      end
    end
  end
end
