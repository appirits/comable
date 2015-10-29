module Comable
  module Inventory
    class Adjuster
      attr_accessor :packages
      attr_accessor :units

      def initialize(packages, units)
        @packages = packages.map(&:clone)
        @units = units
      end

      def adjusted_packages
        remove_duplicated_items
        packages
      end

      private

      def remove_duplicated_items
        units.each do |unit|
          remove_duplicated(unit)
        end
      end

      def remove_duplicated(unit)
        duplicated = false

        packages.each do |package|
          next unless package.find(unit)

          if duplicated
            package.remove(unit)
          else
            duplicated = true
          end
        end
      end
    end
  end
end
