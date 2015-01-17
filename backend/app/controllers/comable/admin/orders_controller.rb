require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class OrdersController < Comable::Admin::ApplicationController
      before_filter :find_order, only: [:show, :edit, :update, :destroy]

      def index
        @orders = Comable::Order.complete.all.page(params[:page]).order('completed_at DESC')
      end

      private

      def find_order
        @order = Comable::Order.find(params[:id])
      end
    end
  end
end
