module Comable
  class OrderDetail < ActiveRecord::Base
    belongs_to :stock, class_name: Comable::Stock.name, foreign_key: Comable::Stock.table_name.singularize.foreign_key
    belongs_to :order_delivery, class_name: Comable::OrderDelivery.name, foreign_key: Comable::OrderDelivery.table_name.singularize.foreign_key

    # TODO: バリデーションの追加

    delegate :product, to: :stock
    delegate :guest_token, to: :order_delivery
    delegate :complete?, to: :order_delivery

    before_save :save_to_add_cart, unless: :complete?

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

    # SKU情報を含めた商品名を取得
    def name_with_sku
      return name unless sku?
      sku_name = sku_h_choice_name
      sku_name += '/' + sku_v_choice_name if sku_v?
      product.name + "(#{sku_name})"
    end

    def sku_h?
      sku_h_item_name.present?
    end

    def sku_v?
      sku_v_item_name.present?
    end

    alias_method :sku?, :sku_h?

    private

    def decrement_stock
      stock.decrement!(quantity: quantity)
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
  end
end
