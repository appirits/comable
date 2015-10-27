module Comable
  class Order < ActiveRecord::Base
    module Callbacks
      extend ActiveSupport::Concern

      included do
        define_model_callbacks :complete

        before_validation :generate_guest_token, on: :create
        before_validation :clone_addresses_from_user, on: :create
        before_complete :packing_items_to_default_shipment, if: -> { shipments.map(&:shipment_items).flatten.empty? }
        before_complete :generate_code
        after_complete :clone_addresses_to_user
      end

      def generate_code
        self.code = loop do
          random_token = "C#{Array.new(11) { rand(9) }.join}"
          break random_token unless self.class.exists?(code: random_token)
        end
      end

      def generate_guest_token
        return if user
        self.guest_token ||= loop do
          random_token = SecureRandom.urlsafe_base64(nil, false)
          break random_token unless self.class.exists?(guest_token: random_token)
        end
      end

      def clone_addresses_from_user
        return unless user
        self.bill_address ||= user.bill_address.try(:clone)
        self.ship_address ||= user.ship_address.try(:clone)
      end

      def clone_addresses_to_user
        return unless user
        user.update_bill_address_by bill_address
        user.update_ship_address_by ship_address
      end

      def packing_items_to_default_shipment
        shipment = shipments.first_or_initialize(&:save!)
        packing_items_to(shipment)
      end
    end
  end
end
