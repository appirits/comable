require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class VariantsController < Comable::Admin::ApplicationController
      load_and_authorize_resource :variant, class: Comable::Variant.name, only: :index

      def index
        @q = @variants.ransack(params[:q])
        @variants = @q.result.includes(:product).page(params[:page]).accessible_by(current_ability).by_newest

        respond_to do |format|
          format.html
          format.json { render json: @variants }
        end
      end

      def show
        render :edit
      end

      def new
      end

      def create
        if @variant.save
          redirect_to comable.admin_product_variant_path(@product, @variant), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def edit
      end

      def update
        if @variant.update_attributes(variant_params)
          redirect_to comable.admin_product_variant_path(@product, @variant), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      def destroy
        @variant.destroy
        redirect_to comable.admin_product_path(@product), notice: Comable.t('successful')
      end

      private

      def variant_params
        params.require(:variant).permit(
          :price,
          :sku,
          stocks_attributes: [:id, :quantity, :stock_location_id, :_destroy],
          option_values_attributes: [:id, :name]
        )
      end
    end
  end
end
