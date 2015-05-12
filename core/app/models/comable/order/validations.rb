module Comable
  class Order < ActiveRecord::Base
    module Validations
      extend ActiveSupport::Concern

      included do
        validates :user_id, uniqueness: { scope: :completed_at }, if: :user
        validates :guest_token, presence: true, uniqueness: { scope: :completed_at }, unless: :user

        with_options if: -> { stated?(:cart) } do |context|
          context.validates :email, presence: true
        end

        with_options if: -> { stated?(:orderer) } do |context|
          context.validates :bill_address, presence: true
        end

        with_options if: -> { stated?(:delivery) } do |context|
          context.validates :ship_address, presence: true
        end

        with_options if: -> { stated?(:payment) && payment_required? } do |context|
          context.validates :payment, presence: true
        end

        with_options if: -> { stated?(:shipment) && shipment_required? } do |context|
          context.validates :shipment, presence: true
        end

        with_options if: -> { stated?(:complete) } do |context|
          context.validates :code, presence: true
          context.validates :payment_fee, presence: true
          context.validates :shipment_fee, presence: true
          context.validates :total_price, presence: true
        end
      end
    end
  end
end
