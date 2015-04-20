require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class OrdersController < Comable::Admin::ApplicationController
      load_and_authorize_resource class: Comable::Order.name, except: :index

      def index
        @q = Comable::Order.complete.ransack(params[:q])
        @orders = @q.result.page(params[:page]).per(15).recent.accessible_by(current_ability)
      end

      def show
      end

      def export
        q = Comable::Order.complete.ransack(params[:q])
        orders = q.result.recent.accessible_by(current_ability)
        order_items = Comable::OrderItem.joins(:order).merge(orders)

        respond_to_export_with order_items
      end

      def cancel
        order = find_order
        order.cancel
        redirect_to comable.admin_order_path(order), notice: Comable.t('successful')
      rescue ActiveRecord::RecordInvalid => e
        redirect_to comable.admin_order_path(order), alert: e.message
      end

      def resume
        order = find_order
        order.resume
        redirect_to comable.admin_order_path(order), notice: Comable.t('successful')
      rescue ActiveRecord::RecordInvalid => e
        redirect_to comable.admin_order_path(order), alert: e.message
      end

      private

      def find_order
        Comable::Order.accessible_by(current_ability).find(params[:id])
      end
    end
  end
end
