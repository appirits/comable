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
          redirect_to comable.admin_products_path, notice: 'Success'
        else
          flash.now[:alert] = 'Failure'
          render :index
        end
      end

      private

      def product_params
        params.require(:product).permit(
          images: []
        )
      end
    end
  end
end
