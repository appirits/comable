module Comable
  module PaymentMethod
    class General < Base
      class << self
        def display_name
          '汎用決済モジュール'
        end

        def kind
          { none: 'なし' }
        end
      end
    end
  end
end
