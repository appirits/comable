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

        respond_to do |format|
          format.csv {
            render csv: order_items, filename: filename
          }
          format.xlsx {
            render xlsx: 'export', filename: filename, locals: { records: order_items }, template: 'comable/admin/shared/export', layout: false
          }
        end
      end
    end
  end
end
