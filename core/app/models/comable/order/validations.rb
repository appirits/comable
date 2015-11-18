module Comable
  class Order < ActiveRecord::Base
    module Validations
      extend ActiveSupport::Concern

      included do
        validates :code, presence: true
        validates :user_id, uniqueness: { scope: :completed_at }, if: -> { user && !draft }
        validates :guest_token, presence: true, uniqueness: { scope: :completed_at }, unless: :user

        with_options if: -> { stated?(:cart) || draft? } do |context|
          context.validates :email, presence: true, length: { maximum: 255 }
        end

        with_options if: -> { stated?(:orderer) || draft? } do |context|
          context.validates :bill_address, presence: true
        end

        with_options if: -> { stated?(:delivery) || draft? } do |context|
          context.validates :ship_address, presence: true
        end

        with_options if: -> { (stated?(:shipment) || draft?) && shipment_required? } do |context|
          context.validates :shipments, presence: true
        end

        with_options if: -> { (stated?(:payment) || draft?) && payment_required? } do |context|
          context.validates :payment, presence: true
        end

        with_options if: -> { stated?(:confirm) } do |context|
          context.validates :payment_fee, presence: true
          context.validates :shipment_fee, presence: true
          context.validates :total_price, presence: true
        end
      end
    end
  end
end
