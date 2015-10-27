module Comable
  class PaymentMethod < ActiveRecord::Base
    validates :name, presence: true, length: { maximum: 255 }
    validates :payment_provider_type, presence: true, length: { maximum: 255 }
    validates :payment_provider_kind, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :enable_price_from, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
    validates :enable_price_to, numericality: { greater_than_or_equal_to: 0, allow_blank: true }

    scope :by_newest, -> { reorder(created_at: :desc) }

    def payment_provider
      return unless Object.const_defined?(payment_provider_type)
      Object.const_get(payment_provider_type)
    end

    def payment_provider_name
      payment_provider.display_name
    end

    def payment_provider_kind_key
      payment_provider.kind.keys.slice(payment_provider_kind)
    end

    def payment_provider_kind_name
      payment_provider.kind.slice(payment_provider_kind_key).values.first
    end
  end
end
