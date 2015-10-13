module Comable
  class Order < ActiveRecord::Base
    module DeprecatedMethods
      extend ActiveSupport::Concern

      def shipment
        shipments.first
      end

      def shipment=(shipment)
        shipments << shipment unless shipments.include? shipment
      end

      included do
        delegate :state, :human_state_name, to: :shipment, allow_nil: true, prefix: true

        #
        # Deprecated methods
        #
        deprecate :shipment, deprecator: Comable::Deprecator.instance
        deprecate :shipment=, deprecator: Comable::Deprecator.instance
        deprecate :shipment_state, deprecator: Comable::Deprecator.instance
        deprecate :shipment_human_state_name, deprecator: Comable::Deprecator.instance
      end
    end
  end
end
