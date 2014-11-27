module Comable
  module PermittedAttributes
    def permitted_address_attributes
      [
        :family_name,
        :first_name,
        :zip_code,
        :state_name,
        :city,
        :detail,
        :phone_number
      ]
    end
  end
end
