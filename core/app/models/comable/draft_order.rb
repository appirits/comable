module Comable
  class DraftOrder
    class << self
      delegate :find, to: Comable::Order.name

      def new(attributes = {})
        Comable::Order.where(draft: true).new(attributes)
      end
    end
  end
end
