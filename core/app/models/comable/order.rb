require_dependency 'comable/order/associations'
require_dependency 'comable/order/callbacks'
require_dependency 'comable/order/scopes'
require_dependency 'comable/order/validations'
require_dependency 'comable/order/morrisable'
require_dependency 'comable/order/deprecated_methods'

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
    include Comable::Order::DeprecatedMethods

    ransack_options attribute_select: { associations: [:payment, :shipments] }, ransackable_attributes: { except: [:bill_address_id, :ship_address_id] }

    liquid_methods :code, :payment_fee, :shipment_fee, :item_total_price, :total_price, :order_items

    delegate :full_name, to: :bill_address, allow_nil: true, prefix: :bill
    delegate :full_name, to: :ship_address, allow_nil: true, prefix: :ship
    delegate :state, :human_state_name, to: :payment, allow_nil: true, prefix: true
    delegate :cancel!, :resume!, to: :payment, allow_nil: true, prefix: true

    attr_writer :same_as_bill_address

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
      shipments.each(&:restock!)
    end

    def unstock!
      shipments.each(&:unstock!)
    end

    def assign_inventory_units_to_shipments
      reset_shipments
      self.shipments = Comable::Inventory::Coordinator.new(self).shipments
      save!
    end

    def reset_shipments
      shipments.destroy_all
    end

    def unstocked_items
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
      shipments.to_a.sum(&:current_fee)
    end

    # Get the current payment fee
    def current_payment_fee
      payment.try(:current_fee) || 0
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

    def draft?
      read_attribute(:draft)
    end

    def paid?
      payment ? payment.completed? : true
    end

    def shipped?
      return true if shipments.empty?
      shipments.all?(&:completed?)
    end

    def can_ship?
      shipments.any?(&:can_ship?)
    end

    def ship!
      shipments.with_state(:ready).each(&:ship!)
    end

    def same_as_bill_address
      @same_as_bill_address.nil? ? bill_address == ship_address : @same_as_bill_address
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
