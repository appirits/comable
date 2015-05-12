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
        @order.cancel!
        redirect_to :back, notice: Comable.t('successful')
      rescue ActiveRecord::RecordInvalid => e
        redirect_to :back, alert: e.message
      end

      def resume
        @order.resume!
        redirect_to :back, notice: Comable.t('successful')
      rescue ActiveRecord::RecordInvalid => e
        redirect_to :back, alert: e.message
      end

      def cancel_payment
        @order.payment.cancel!
        redirect_to :back, notice: Comable.t('successful')
      rescue ActiveRecord::RecordInvalid => e
        redirect_to :back, alert: e.message
      end

      def resume_payment
        @order.payment.resume!
        redirect_to :back, notice: Comable.t('successful')
      rescue ActiveRecord::RecordInvalid => e
        redirect_to :back, alert: e.message
      end

      def ship
        @order.shipment.ship!
        redirect_to :back, notice: Comable.t('successful')
      rescue ActiveRecord::RecordInvalid => e
        redirect_to :back, alert: e.message
      end

      def cancel_shipment
        @order.shipment.cancel!
        redirect_to :back, notice: Comable.t('successful')
      rescue ActiveRecord::RecordInvalid => e
        redirect_to :back, alert: e.message
      end

      def resume_shipment
        @order.shipment.resume!
        redirect_to :back, notice: Comable.t('successful')
      rescue ActiveRecord::RecordInvalid => e
        redirect_to :back, alert: e.message
      end
    end
  end
end
