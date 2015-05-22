module Comable
  module Sample
    module PhoneNumber
      class << self
        def phone_number
          FFaker::PhoneNumber.phone_number
        end
      end
    end
  end
end
