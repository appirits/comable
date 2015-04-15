require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ProductsController < Comable::Admin::ApplicationController
      load_and_authorize_resource class: Comable::Product.name, except: :index

      def index
        @q = Comable::Product.ransack(params[:q])
        @products = @q.result(distinct: true).includes(:stocks, :images).page(params[:page]).accessible_by(current_ability)
      end

      def show
        render :edit
      end

      def new
      end

      def create
        if @product.save
          redirect_to comable.admin_product_path(@product), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def edit
      end

      def update
        if @product.update_attributes(product_params)
          redirect_to comable.admin_product_path(@product), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      def destroy
        if @product.destroy
          redirect_to comable.admin_products_path, notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      def export
        q = Comable::Product.ransack(params[:q])
        products = q.result.accessible_by(current_ability)

        respond_to_export_with products
      end

      private

      def product_params
        params.require(:product).permit(
          :name,
          :code,
          :caption,
          :price,
          :sku_h_item_name,
          :sku_v_item_name,
          category_path_names: [],
          images_attributes: [:id, :file, :_destroy]
        )
      end
    end
  end
end
