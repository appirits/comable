module Comable
  class OrderDetail < ActiveRecord::Base
    include Comable::SkuItem
    include Comable::SkuChoice

    belongs_to :stock, class_name: Comable::Stock.name, foreign_key: Comable::Stock.table_name.singularize.foreign_key
    belongs_to :order_delivery, class_name: Comable::OrderDelivery.name, foreign_key: Comable::OrderDelivery.table_name.singularize.foreign_key

    accepts_nested_attributes_for :stock

    # TODO: バリデーションの追加

    delegate :product, to: :stock
    delegate :guest_token, to: :order_delivery
    delegate :complete?, to: :order_delivery
    delegate :order, to: :order_delivery

    before_save :save_to_add_cart, unless: :complete?
    before_save :verify_quantity, unless: :complete?

    def save_to_complete
      self.attributes = current_attributes
      decrement_stock
    end

    # TODO: カート投入時との差額表示
    def save_to_add_cart
      self.attributes = current_attributes
    end

    # 時価を取得
    def current_price
      stock.price
    end

    # 時価小計を取得
    def current_subtotal_price
      current_price * quantity
    end

    # 売価小計を取得
    def subtotal_price
      price * quantity
    end

    def valid_order_quantity?
      if quantity <= 0
        add_order_quantity_invalid_error_to_order
        return false
      end

      if stock.soldout?(quantity: quantity)
        add_product_soldout_error_to_order
        return false
      end

      true
    end

    private

    def decrement_stock
      return unless quantity
      return unless stock.quantity
      stock.quantity -= quantity
    end

    def verify_quantity
      fail Comable::NoStock if stock.soldout?(quantity: quantity)
    end

    def current_attributes
      {
        name: product.name,
        code: stock.code,
        price: stock.price,
        sku_h_item_name: product.sku_h_item_name,
        sku_v_item_name: product.sku_v_item_name,
        sku_h_choice_name: stock.sku_h_choice_name,
        sku_v_choice_name: stock.sku_v_choice_name
      }
    end

    def add_order_quantity_invalid_error_to_order
      order.errors.add :base, I18n.t('comable.errors.messages.order_quantity_invalid', name: stock.name_with_sku)
    end

    def add_product_soldout_error_to_order
      order.errors.add :base, I18n.t('comable.errors.messages.product_soldout', name: stock.name_with_sku)
    end
  end
end
