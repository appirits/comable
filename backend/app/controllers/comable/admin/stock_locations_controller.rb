require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class StockLocationsController < Comable::Admin::ApplicationController
      include Comable::PermittedAttributes

      load_and_authorize_resource class: Comable::StockLocation.name

      before_filter :build_address, only: [:show, :new, :edit]

      def index
      end

      def show
        render :edit
      end

      def new
        @stock_location.build_address unless @stock_location.address
      end

      def create
        if @stock_location.save
          redirect_to comable.admin_stock_location_path(@stock_location), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def edit
      end

      def update
        if @stock_location.update_attributes(stock_location_params)
          redirect_to comable.admin_stock_location_path(@stock_location), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      def destroy
        @stock_location.destroy
        redirect_to comable.admin_stock_locations_path, notice: Comable.t('successful')
      end

      private

      def stock_location_params
        params.require(:stock_location).permit(
          :name,
          :active,
          :default,
          address_attributes: permitted_address_attributes
        ).tap do |params|
          next unless params[:address_attributes]
          next if params[:address_attributes].values.any?(&:present?)
          params.delete(:address_attributes)
        end
      end

      def build_address
        @stock_location.build_address unless @stock_location.address
      end
    end
  end
end
