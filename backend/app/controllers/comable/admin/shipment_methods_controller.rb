require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ShipmentMethodsController < Comable::Admin::ApplicationController
      # GET /admin/shipment_methods
      def index
        @shipment_methods = Comable::ShipmentMethod.all
      end

      # GET /admin/shipment_methods/1
      def show
        @shipment_method = Comable::ShipmentMethod.find(params[:id])
      end

      # GET /admin/shipment_methods/new
      def new
        @shipment_method = Comable::ShipmentMethod.new
      end

      # GET /admin/shipment_methods/1/edit
      def edit
        @shipment_method = Comable::ShipmentMethod.find(params[:id])
      end

      # POST /admin/shipment_methods
      def create
        @shipment_method = Comable::ShipmentMethod.new(shipment_method_params)

        if @shipment_method.save
          redirect_to comable.admin_shipment_method_url(@shipment_method), notice: 'Shipment method was successfully created.'
        else
          render :new
        end
      end

      # PATCH/PUT /admin/shipment_methods/1
      def update
        @shipment_method = Comable::ShipmentMethod.find(params[:id])
        if @shipment_method.update(shipment_method_params)
          redirect_to comable.admin_shipment_method_url(@shipment_method), notice: 'Shipment method was successfully updated.'
        else
          render :edit
        end
      end

      # DELETE /admin/shipment_methods/1
      def destroy
        @shipment_method = Comable::ShipmentMethod.find(params[:id])
        @shipment_method.destroy
        redirect_to comable.admin_shipment_methods_url, notice: 'Shipment method was successfully destroyed.'
      end

      private

      # Only allow a trusted parameter "white list" through.
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
