require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ShipmentMethodsController < Comable::Admin::ApplicationController
      before_filter :find_shipment_method, only: [:show, :edit, :update, :destroy]

      def index
        @shipment_methods = Comable::ShipmentMethod.page(params[:page]).all
      end

      def show
        render :edit
      end

      def new
        @shipment_method = Comable::ShipmentMethod.new
      end

      def create
        @shipment_method = Comable::ShipmentMethod.new
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

      def find_shipment_method
        @shipment_method = Comable::ShipmentMethod.find(params[:id])
      end

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
