module Comable
  class PaymentMethod < ActiveRecord::Base
    validates :name, presence: true
    validates :payment_provider_type, presence: true
    validates :payment_provider_kind, presence: true

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
