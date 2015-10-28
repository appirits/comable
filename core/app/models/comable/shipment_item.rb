module Comable
  class ShipmentItem < ActiveRecord::Base
    belongs_to :shipment, class_name: Comable::Shipment.name
    belongs_to :stock, class_name: Comable::Stock.name

    validates :shipment, presence: true
    validates :stock, presence: true

    attr_accessor :variant

    def ready!
      decrement_stock!
    end

    def restock!
      increment_stock!
    end

    def unstock!
      decrement_stock!
    end

    private

    def decrement_stock!
      change_stock!(-1)
    end

    def increment_stock!
      change_stock!(+1)
    end

    def change_stock!(required)
      stock.lock!
      stock.quantity += required
      stock_save!
    end

    # Add the error to Order when fails #save! for compatibility
    def stock_save!
      stock.save!
    rescue ActiveRecord::RecordInvalid => e
      shipment.order.errors.add 'order_items.quantity', Comable.t('errors.messages.out_of_stock', name: stock.name_with_sku)
      raise e, Comable.t('errors.messages.out_of_stock', name: stock.name_with_sku)
    end
  end
end
