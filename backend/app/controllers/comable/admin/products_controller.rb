require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ProductsController < Comable::Admin::ApplicationController
      before_filter :find_product, only: [:show, :edit, :update, :destroy]

      def index
        @products = Comable::Product.all
      end

      def new
        @product = Comable::Product.new
      end

      def create
        @product = Comable::Product.new
        if @product.update_attributes(product_params)
          redirect_to comable.admin_product_path(@product), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def update
        if @product.update_attributes(product_params)
          redirect_to comable.admin_product_path(@product), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :show
        end
      end

      private

      def find_product
        @product = Comable::Product.includes(:images).find(params[:id])
      end

      def product_params
        params.require(:product).permit(
          :name,
          :code,
          :caption,
          :price,
          images_attributes: [:id, :file, :_destroy]
        )
      end
    end
  end
end
