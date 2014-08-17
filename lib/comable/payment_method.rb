require 'comable/payment_method/base'
require 'comable/payment_method/general'

module Comable
  module PaymentMethod
    class << self
      def all
        (constants - [:Base]).map do |constant_name|
          const_get(constant_name)
        end
      end
    end
  end
end
