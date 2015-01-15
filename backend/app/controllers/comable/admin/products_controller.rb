require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ProductsController < Comable::Admin::ApplicationController
      before_filter :find_product, only: [:show, :edit, :update, :destroy]

      def index
        @products = Comable::Product.all
      end

      def update
        if @product.update_attributes(product_params)
          redirect_to comable.admin_products_path, notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          # TODO: Implement 'show' action
          render :index
        end
      end

      private

      def find_product
        @product = Comable::Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(
          images_attributes: [:file]
        )
      end
    end
  end
end
