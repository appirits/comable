module Comable
  class OrderItem < ActiveRecord::Base
    include Comable::SkuItem
    include Comable::SkuChoice
    include Comable::Liquidable
    include Comable::OrderItem::Csvable

    belongs_to :variant, class_name: Comable::Variant.name, autosave: true
    belongs_to :order, class_name: Comable::Order.name, inverse_of: :order_items

    validates :quantity, numericality: { greater_than: 0 }
    validates :sku, length: { maximum: 255 }
    validate :valid_stock_quantity

    liquid_methods :name, :name_with_sku, :code, :quantity, :price, :subtotal_price

    delegate :product, to: :variant
    delegate :image_url, to: :product
    delegate :guest_token, to: :order
    delegate :completed?, to: :order, allow_nil: true

    before_validation :copy_attributes, unless: :completed?

    def complete
      unstock
    end

    def unstock
      decrement_stock
    end

    def restock
      increment_stock
    end

    # TODO: カート投入時との差額表示
    def copy_attributes
      self.attributes = current_attributes
    end

    # 時価を取得
    def current_price
      variant.price
    end

    # 時価小計を取得
    def current_subtotal_price
      current_price * quantity
    end

    # 売価小計を取得
    def subtotal_price
      price * quantity
    end

    def unstocked?
      stock_with_clean_quantity do |stock|
        stock.unstocked?(quantity: quantity)
      end
    end

    def sku_h_item_name
      product.option_types.first.try(:name)
    end

    def sku_v_item_name
      product.option_types.second.try(:name)
    end

    def sku_h_choice_name
      variant.option_values.first.try(:name)
    end

    def sku_v_choice_name
      variant.option_values.second.try(:name)
    end

    def stock
      variant.stocks.first
    end

    def stock=(stock)
      self.variant = stock.variant
    end

    #
    # Deprecated methods
    #
    deprecate :stock, deprecator: Comable::Deprecator.instance
    deprecate :stock=, deprecator: Comable::Deprecator.instance
    deprecate :sku_h_item_name, deprecator: Comable::Deprecator.instance
    deprecate :sku_v_item_name, deprecator: Comable::Deprecator.instance
    deprecate :sku_h_choice_name, deprecator: Comable::Deprecator.instance
    deprecate :sku_v_choice_name, deprecator: Comable::Deprecator.instance

    private

    def valid_stock_quantity
      return unless unstocked?
      errors.add :quantity, Comable.t('errors.messages.out_of_stock', name: stock.name_with_sku)
    end

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

    def increment_stock
      stock.lock!
      stock.quantity += quantity
    end

    def current_attributes
      {
        name: variant.name,
        price: variant.price,
        sku: variant.sku
      }
    end
  end
end
