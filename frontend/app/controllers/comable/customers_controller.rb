module Comable
  class CustomersController < Comable::ApplicationController
    include Comable::PermittedAttributes

    before_filter :authenticate_customer!

    def show
      @orders = current_customer.orders.page(params[:page]).per(Comable::Config.orders_per_page)
    end

    def update_addresses
      current_customer.attributes = customer_params
      if current_customer.save
        flash.now[:notice] = Comable.t('successful')
      else
        flash.now[:alert] = Comable.t('failure')
      end
      render :addresses
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
