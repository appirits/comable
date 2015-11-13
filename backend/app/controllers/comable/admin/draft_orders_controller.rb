require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class DraftOrdersController < Comable::Admin::ApplicationController
      include Comable::PermittedAttributes

      load_and_authorize_resource :order, parent: false, class: Comable::DraftOrder.name

      def index
        @q = Comable::Order.draft.ransack(params[:q])
        @orders = @q.result.page(params[:page]).per(15).recent.accessible_by(current_ability)
      end

      def show
        render :edit
      end

      def new
        build_associations
      end

      def create
        if save_order_as_draft
          redirect_to admin_order_path, notice: Comable.t('successful')
        else
          build_associations
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def edit
      end

      def update
        @order.attributes = order_params

        if save_order_as_draft
          @order.update!(draft: false) if @order.completed?
          redirect_to admin_order_path, notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      private

      def admin_order_path
        if @order.draft?
          comable.admin_draft_order_path(@order)
        else
          comable.admin_order_path(@order)
        end
      end

      def save_order_as_draft
        @order.next_draft_state
      rescue ActiveRecord::RecordInvalid
        false
      end

      # rubocop:disable Metrics/MethodLength
      def order_params
        params.require(:order).permit(
          :id,
          :user_id,
          :email,
          :same_as_bill_address,
          bill_address_attributes: permitted_address_attributes,
          ship_address_attributes: permitted_address_attributes,
          order_items_attributes: [:id, :name, :sku, :price, :quantity, :variant_id],
          payment_attributes: [:id, :_destroy, :payment_method_id],
          shipments_attributes: [:id, :_destroy, :shipment_method_id]
        )
      end
      # rubocop:enable Metrics/MethodLength

      def build_associations
        @order.build_bill_address unless @order.bill_address
        @order.build_ship_address unless @order.ship_address
        @order.build_payment unless @order.payment
      end
    end
  end
end
