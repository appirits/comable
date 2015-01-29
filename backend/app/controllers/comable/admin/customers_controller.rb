require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class CustomersController < Comable::Admin::ApplicationController
      include Comable::PermittedAttributes

      load_and_authorize_resource class: Comable::Customer.name, except: :index

      def index
        @q = Comable::Customer.ransack(params[:q])
        @customers = @q.result.page(params[:page]).accessible_by(current_ability)
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

      def customer_params
        params.require(:customer).permit(
          :email,
          :password,
          bill_address_attributes: permitted_address_attributes
        )
      end
    end
  end
end
