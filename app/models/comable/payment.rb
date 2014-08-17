module Comable
  class Payment < ActiveRecord::Base
    include Decoratable

    validates :name, presence: true
    validates :payment_method_type, presence: true
    validates :payment_method_kind, presence: true

    def payment_method
      return unless Object.const_defined?(payment_method_type)
      Object.const_get(payment_method_type)
    end

    def payment_method_name
      payment_method.display_name
    end

    def payment_method_kind_key
      payment_method.kind.keys.slice(payment_method_kind)
    end

    def payment_method_kind_name
      payment_method.kind.slice(payment_method_kind_key).values.first
    end
  end
end
