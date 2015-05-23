module Comable
  module Sample
    module Address
      class << self
        def zip_code
          FFaker::AddressUS.zip_code
        end

        def state_name
          FFaker::AddressUS.state
        end

        def city
          FFaker::AddressUS.city
        end

        def detail
          FFaker::AddressUS.street_address
        end
      end
    end
  end
end
