module Comable
  class Variant < ActiveRecord::Base
    module Quantifier
      def total_quantity
        if track_inventory?
          stocks.to_a.sum(&:quantity)
        else
          Float::INFINITY
        end
      end

      def can_supply?(required = 1)
        quantity >= required || backorderable?
      end

      # TODO: Implement
      def track_inventory?
        true
      end

      # TODO: Implement
      def backorderable?
        false
      end
    end
  end
end
