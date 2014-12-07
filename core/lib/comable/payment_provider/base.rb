module Comable
  module PaymentProvider
    class Base
      class << self
        def name_symbol
          name.demodulize.underscore.to_sym
        end

        def display_name
          please_implement_method
        end

        def kind
          please_implement_method
        end

        private

        def please_implement_method
          calling_method_name = caller_locations(1, 1).first.label
          fail "You should implement '#{calling_method_name}' method in #{name}."
        end
      end
    end
  end
end
