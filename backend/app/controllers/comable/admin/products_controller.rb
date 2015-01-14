require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ProductsController < Comable::Admin::ApplicationController
      def index
        @products = Comable::Product.all
      end

      def update
        product = Comable::Product.find(params[:id])
        product.attributes = product_params
        if product.save
          redirect_to comable.admin_products_path, notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :index
        end
      end

      private

      def product_params
        params.require(:product).permit(
          images_attributes: [:file]
        )
      end
    end
  end
end
