require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class StocksController < Comable::Admin::ApplicationController
      load_and_authorize_resource :product, class: Comable::Product.name
      load_and_authorize_resource :stock, class: Comable::Stock.name, through: :product

      before_filter :redirect_to_show_when_nonsku_product, only: :index

      def show
        render :edit
      end

      def index
        @q = @product.stocks.ransack(params[:q])
        @stocks = @q.result.includes(:product).page(params[:page]).accessible_by(current_ability)
      end

      def create
        if @stock.update_attributes(stock_params)
          redirect_to comable.admin_product_stock_path(@product, @stock), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def update
        if @stock.update_attributes(stock_params)
          redirect_to comable.admin_product_stock_path(@product, @stock), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      def destroy
        if @stock.destroy
          redirect_to comable.admin_product_stocks_path(@product), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      private

      def stock_params
        params.require(:stock).permit(
          :code,
          :quantity,
          :sku_h_choice_name,
          :sku_v_choice_name
        )
      end

      def redirect_to_show_when_nonsku_product
        return if @product.sku?

        if @product.stocks.first
          redirect_to comable.admin_product_stock_path(@product, @product.stocks.first)
        else
          redirect_to comable.new_admin_product_stock_path(@product)
        end
      end
    end
  end
end
