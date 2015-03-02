require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class StocksController < Comable::Admin::ApplicationController
      load_and_authorize_resource :stock, class: Comable::Stock.name, except: [:new, :create]

      load_and_authorize_resource :product, class: Comable::Product.name, only: [:new, :create]
      load_and_authorize_resource :stock, class: Comable::Stock.name, through: :product, only: [:new, :create]

      def index
        @q = @stocks.ransack(params[:q])
        @stocks = @q.result.includes(:product).page(params[:page]).accessible_by(current_ability)
      end

      def show
        render :edit
      end

      def new
      end

      def create
        if @stock.save
          redirect_to comable.admin_stock_path(@stock), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def edit
      end

      def update
        if @stock.update_attributes(stock_params)
          redirect_to comable.admin_stock_path(@stock), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      def destroy
        if @stock.destroy
          redirect_to comable.admin_stocks_path, notice: Comable.t('successful')
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
    end
  end
end
