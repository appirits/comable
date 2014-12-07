module Comable
  class OrderDetail < ActiveRecord::Base
    include Comable::SkuItem
    include Comable::SkuChoice

    belongs_to :stock, class_name: Comable::Stock.name, autosave: true
    belongs_to :order, class_name: Comable::Order.name, inverse_of: :order_details

    validates :quantity, numericality: { greater_than: 0 }
    validate :valid_stock_quantity

    delegate :product, to: :stock
    delegate :guest_token, to: :order
    delegate :completed?, to: :order, allow_nil: true
    delegate :completing?, to: :order, allow_nil: true

    with_options if: -> { !completed? || completing? } do |incomplete|
      incomplete.before_validation :copy_attributes
    end

    def complete
      copy_attributes
      decrement_stock
    end

    # TODO: カート投入時との差額表示
    def copy_attributes
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

    def soldout_stock?
      stock_with_clean_quantity do |stock|
        stock.soldout?(quantity: quantity)
      end
    end

    def valid_stock_quantity
      return unless soldout_stock?
      errors.add :quantity, I18n.t('comable.errors.messages.product_soldout', name: stock.name_with_sku)
    end

    private

    def stock_with_clean_quantity
      quantity_will = stock.quantity
      stock.quantity = stock.quantity_was if stock.quantity_was
      yield stock
    ensure
      stock.quantity = quantity_will
    end

    def decrement_stock
      stock.lock!
      stock.quantity -= quantity
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
