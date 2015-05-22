module Comable
  module Sample
    module Name
      class << self
        def family_name
          FFaker::Name.last_name
        end

        def first_name
          FFaker::Name.first_name
        end
      end
    end
  end
end
