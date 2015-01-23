require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class PaymentMethodsController < Comable::Admin::ApplicationController
      before_filter :find_payment_method, only: [:show, :edit, :update, :destroy]

      def index
        @payment_methods = Comable::PaymentMethod.page(params[:page]).all
      end

      def show
        render :edit
      end

      def new
        @payment_method = Comable::PaymentMethod.new
      end

      def create
        @payment_method = Comable::PaymentMethod.new
        if @payment_method.update_attributes(payment_method_params)
          redirect_to comable.admin_payment_method_path(@payment_method), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def update
        if @payment_method.update_attributes(payment_method_params)
          redirect_to comable.admin_payment_method_path(@payment_method), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      def destroy
        @payment_method.destroy
        redirect_to comable.admin_payment_methods_path, notice: Comable.t('successful')
      end

      private

      def find_payment_method
        @payment_method = Comable::PaymentMethod.find(params[:id])
      end

      def payment_method_params
        params.require(:payment_method).permit(
          :name,
          :payment_provider_type,
          :payment_provider_kind,
          :enable_price_from,
          :enable_price_to
        )
      end
    end
  end
end
