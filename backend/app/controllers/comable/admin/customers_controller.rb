require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class CustomersController < Comable::Admin::ApplicationController
      before_filter :find_customer, only: [:show, :edit, :update, :destroy]

      def index
        @customers = Comable::Customer.page(params[:page])
        @customers = @customers.where!('email LIKE ?', "%#{params[:search_email]}%") if params[:search_email].present?
      end

      def update
        if @customer.update_attributes(customer_params)
          redirect_to comable.admin_customer_path(@customer), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      private

      def find_customer
        @customer = Comable::Customer.find(params[:id])
      end

      def customer_params
        params.require(:customer).permit(
          :email,
          :password,
          bill_address_attributes: [
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
end
