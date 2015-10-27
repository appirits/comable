module Comable
  class ShipmentItem < ActiveRecord::Base
    belongs_to :shipment, class_name: Comable::Shipment.name
    belongs_to :stock, class_name: Comable::Stock.name

    validates :shipment, presence: true
    validates :stock, presence: true

    def ready!
      decrement_stock!
    end

    private

    def decrement_stock!
      stock.lock!
      stock.quantity -= 1
      begin
        stock.save!
      rescue ActiveRecord::RecordInvalid => e
        shipment.order.errors.add 'order_items.quantity', Comable.t('errors.messages.out_of_stock', name: stock.name_with_sku)
        raise e, Comable.t('errors.messages.out_of_stock', name: stock.name_with_sku)
      end
    end
  end
end
