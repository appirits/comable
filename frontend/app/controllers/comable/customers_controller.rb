module Comable
  class CustomersController < Comable::ApplicationController
    before_filter :authenticate_customer!

    def show
    end

    def addresses
      return unless request.put?

      if current_customer.update_attributes(customer_params)
        flash.now[:notice] = 'Success'
      end
    end

    def customer_params
      params.require(:customer).permit(
        :bill_address_id,
        :ship_address_id,
        addresses_attributes: [
          :family_name,
          :first_name,
          :zip_code,
          :state_name,
          :city,
          :detail,
          :phone_number
        ]
      )
    end
  end
end
