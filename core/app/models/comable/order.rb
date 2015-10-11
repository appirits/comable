require_dependency 'comable/order/associations'
require_dependency 'comable/order/callbacks'
require_dependency 'comable/order/scopes'
require_dependency 'comable/order/validations'
require_dependency 'comable/order/morrisable'

module Comable
  class Order < ActiveRecord::Base
    include Comable::Checkout
    include Comable::Ransackable
    include Comable::Liquidable
    include Comable::Order::Associations
    include Comable::Order::Callbacks
    include Comable::Order::Scopes
    include Comable::Order::Validations
    include Comable::Order::Morrisable

    ransack_options attribute_select: { associations: [:payment, :shipments] }, ransackable_attributes: { except: [:bill_address_id, :ship_address_id] }

    liquid_methods :code, :payment_fee, :shipment_fee, :item_total_price, :total_price, :order_items

    delegate :full_name, to: :bill_address, allow_nil: true, prefix: :bill
    delegate :full_name, to: :ship_address, allow_nil: true, prefix: :ship
    delegate :state, :human_state_name, to: :payment, allow_nil: true, prefix: true
    delegate :state, :human_state_name, to: :shipment, allow_nil: true, prefix: true
    delegate :cancel!, :resume!, to: :payment, allow_nil: true, prefix: true

    def complete!
      ActiveRecord::Base.transaction do
        run_callbacks :complete do
          self.attributes = current_attributes

          order_items.each(&:complete)
          save!

          payment.next_state! if payment
          shipments.each(&:next_state!)

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
      shipments.to_a.sum(&:fee)
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
      self.shipments = order.shipments if shipments.empty?

      stated?(order.state) ? save! : next_state!
    end

    def completed?
      completed_at?
    end

    def paid?
      payment ? payment.completed? : true
    end

    def shipped?
      return true if shipments.empty?
      shipments.all?(&:completed?)
    end

    def can_ship?
      shipments.all?(&:ready?) && paid? && completed?
    end

    def shipment
      shipments.first
    end

    def shipment=(shipment)
      shipments << shipment unless shipments.include? shipment
    end

    private

    def current_attributes
      {
        payment_fee: current_payment_fee,
        shipment_fee: current_shipment_fee,
        total_price: current_total_price
      }
    end

    #
    # Deprecated methods
    #
    deprecate :shipment, deprecator: Comable::Deprecator.instance
    deprecate :shipment=, deprecator: Comable::Deprecator.instance
  end
end
