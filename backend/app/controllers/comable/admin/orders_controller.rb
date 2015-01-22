require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class OrdersController < Comable::Admin::ApplicationController
      before_filter :find_order, only: [:show, :edit, :update, :destroy]

      def index
        @orders = Comable::Order.complete.page(params[:page]).per(15).order('completed_at DESC')
        @orders = @orders.where!('code LIKE ?', "%#{params[:search_code]}%") if params[:search_code].present?
        @orders = @orders.where!(customer_id: params[:search_customer_id]) if params[:search_customer_id].present?
      end

      private

      def find_order
        @order = Comable::Order.find(params[:id])
      end
    end
  end
end
