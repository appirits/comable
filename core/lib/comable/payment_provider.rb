require 'comable/payment_provider/base'
require 'comable/payment_provider/general'

module Comable
  module PaymentProvider
    class << self
      def all
        (constants - [:Base]).map do |constant_name|
          const_get(constant_name)
        end
      end
    end
  end
end
