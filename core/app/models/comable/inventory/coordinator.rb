module Comable
  module Inventory
    class Coordinator
      attr_accessor :order
      attr_accessor :units

      def initialize(order)
        @order = order
        @units = build_units
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
          next unless units_exists_in? stock_location
          build_packer(stock_location).package
        end.compact
      end

      def adjust_packages(packages)
        Adjuster.new(packages, units).adjusted_packages
      end

      def compact_packages(packages)
        packages.reject(&:empty?)
      end

      def units_exists_in?(stock_location)
        stock_location.stocks.where(variant: units.map(&:variant).uniq).exists?
      end

      def build_packer(stock_location)
        Packer.new(stock_location, units)
      end

      def build_units
        order.order_items.map do |order_item|
          order_item.quantity.times.map do
            Unit.new(order_item.variant)
          end
        end.flatten
      end
    end
  end
end
