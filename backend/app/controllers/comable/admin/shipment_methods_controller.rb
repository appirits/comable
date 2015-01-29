require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ShipmentMethodsController < Comable::Admin::ApplicationController
      load_and_authorize_resource class: Comable::ShipmentMethod.name

      def index
        @shipment_methods = @shipment_methods.page(params[:page])
      end

      def show
        render :edit
      end

      def create
        if @shipment_method.update_attributes(shipment_method_params)
          redirect_to comable.admin_shipment_method_path(@shipment_method), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def update
        if @shipment_method.update_attributes(shipment_method_params)
          redirect_to comable.admin_shipment_method_path(@shipment_method), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      def destroy
        @shipment_method.destroy
        redirect_to comable.admin_shipment_methods_path, notice: Comable.t('successful')
      end

      private

      def shipment_method_params
        params.require(:shipment_method).permit(
          :activate_flag,
          :name,
          :fee,
          :traking_url
        )
      end
    end
  end
end
