require_dependency 'comable/order/associations'
require_dependency 'comable/order/callbacks'
require_dependency 'comable/order/scopes'
require_dependency 'comable/order/validations'
require_dependency 'comable/order/morrisable'

module Comable
  class Order < ActiveRecord::Base
    include Comable::Checkout
    include Comable::Ransackable
    include Comable::Order::Associations
    include Comable::Order::Callbacks
    include Comable::Order::Scopes
    include Comable::Order::Validations
    include Comable::Order::Morrisable

    ransack_options attribute_select: { associations: [:payment, :shipment] }, ransackable_attributes: { except: [:bill_address_id, :ship_address_id] }

    delegate :full_name, to: :bill_address, allow_nil: true, prefix: :bill
    delegate :full_name, to: :ship_address, allow_nil: true, prefix: :ship
    delegate :state, :human_state_name, to: :payment, allow_nil: true, prefix: true
    delegate :state, :human_state_name, to: :shipment, allow_nil: true, prefix: true

    def complete!
      ActiveRecord::Base.transaction do
        run_callbacks :complete do
          self.attributes = current_attributes

          order_items.each(&:complete)
          save!

          payment.next_state! if payment
          shipment.next_state! if shipment

          touch(:completed_at)
        end
      end
    end

    alias_method :complete, :complete!
    deprecate :complete, deprecator: Comable::Deprecator.instance

    def restock!
      order_items.each(&:restock)
      save!
    end

    def unstock!
      order_items.each(&:unstock)
      save!
    end

    def stocked_items
      order_items.to_a.select(&:unstocked?)
    end

    # 時価商品合計を取得
    def current_item_total_price
      order_items.to_a.sum(&:current_subtotal_price)
    end

    # 売価商品合計を取得
    def item_total_price
      order_items.to_a.sum(&:subtotal_price)
    end

    # 時価送料を取得
    def current_shipment_fee
      shipment.try(:fee) || 0
    end

    # Get the current payment fee
    def current_payment_fee
      payment.try(:fee) || 0
    end

    # 時価合計を取得
    def current_total_price
      current_item_total_price + current_payment_fee + current_shipment_fee
    end

    # Inherit from other Order
    def inherit!(order)
      self.bill_address ||= order.bill_address
      self.ship_address ||= order.ship_address
      self.payment ||= order.payment
      self.shipment ||= order.shipment

      stated?(order.state) ? save! : next_state!
    end

    def paid?
      payment ? payment.completed? : true
    end

    def shipped?
      shipment ? shipment.completed? : true
    end

    def can_ship?
      shipment && shipment.ready? && paid? && completed?
    end

    private

    def current_attributes
      {
        payment_fee: current_payment_fee,
        shipment_fee: current_shipment_fee,
        total_price: current_total_price
      }
    end
  end
end
