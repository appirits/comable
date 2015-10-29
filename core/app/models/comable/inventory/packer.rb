module Comable
  module Inventory
    class Packer
      attr_accessor :stock_location
      attr_accessor :units

      def initialize(stock_location, units)
        @stock_location = stock_location
        @units = units
      end

      def package
        package = Package.new(stock_location)

        units.group_by(&:variant).each do |variant, variant_units|
          stock = stock_location.find_stock_item(variant)
          next unless stock
          package.add variant_units.take(stock.quantity) if stock.stocked?
        end

        package
      end
    end
  end
end
