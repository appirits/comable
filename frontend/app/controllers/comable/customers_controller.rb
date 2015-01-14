module Comable
  class CustomersController < Comable::ApplicationController
    include Comable::PermittedAttributes

    before_filter :authenticate_customer!

    def show
      @orders = current_customer.orders.page(params[:page])
    end

    def addresses
      return unless request.put?

      current_customer.attributes = customer_params
      if current_customer.save
        flash.now[:notice] = Comable.t('successful')
      else
        flash.now[:alert] = Comable.t('failure')
      end
    end

    def customer_params
      params.require(:customer).permit(
        :bill_address_id,
        :ship_address_id,
        addresses_attributes: permitted_address_attributes
      )
    end
  end
end
