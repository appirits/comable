module Comable
  #
  # 在庫モデル。
  # 商品に複数紐付き、品数やSKU(Stock Keeping Unit)情報を保持する。
  #
  class Stock < ActiveRecord::Base
    include Comable::SkuItem
    include Comable::SkuChoice
    include Comable::Ransackable
    include Comable::Liquidable
    include Comable::Stock::Csvable

    belongs_to :variant, class_name: Comable::Variant.name, inverse_of: :stock
    belongs_to :stock_location, class_name: Comable::StockLocation.name

    #
    # @!group Scope
    #

    # @!scope class
    # 品切れでない在庫インスタンスを返す
    scope :stocked, -> { where('quantity > ?', 0) }

    # @!scope class
    # 品切れの在庫インスタンスを返す
    scope :unstocked, -> { where('quantity <= ?', 0) }

    #
    # @!endgroup
    #

    # TODO: add conditions (by limitless flag, backoder flag and etc..)
    validates :quantity, numericality: { greater_than_or_equal_to: 0 }

    # TODO: Remove the columns for compatible
    delegate :product, to: :variant
    delegate :price, to: :variant
    delegate :sku_h_item_name, to: :product
    delegate :sku_v_item_name, to: :product

    ransack_options attribute_select: { associations: :variant }, ransackable_attributes: { only: :quantity }

    # 在庫の有無を取得する
    #
    # @example
    #   stock.quanaity = 1
    #   stock.stocked? #=> true
    #
    # @param quantity [Fixnum] 減算する在庫数を指定する
    # @return [Boolean] 在庫があれば true を返す
    # @see #unstocked?
    def stocked?(quantity: 1)
      (self.quantity - quantity) >= 0
    end

    # 在庫の有無を取得する
    #
    # @example
    #   stock.quanaity = 1
    #   stock.unstocked? #=> false
    #
    # @param quantity [Fixnum] 減算する在庫数を指定する
    # @return [Boolean] {#stocked?} の逆。在庫がなければ true を返す
    # @see #stocked?
    def unstocked?(quantity: 1)
      !stocked?(quantity: quantity)
    end

    def name
      if variant.options.any?
        "#{variant.product.name} (#{variant.options.map(&:value).join('/')})"
      else
        variant.product.name
      end
    end

    def sku_h_choice_name
      variant.option_values.first.try(:name)
    end

    def sku_v_choice_name
      variant.option_values.second.try(:name)
    end

    def code
      variant.sku
    end

    def product=(product)
      if variant
        variant.product = product
      else
        build_variant(product: product)
      end
    end

    #
    # Deprecated methods
    #
    deprecate :product, deprecator: Comable::Deprecator.instance
    deprecate :name, deprecator: Comable::Deprecator.instance
    deprecate :code, deprecator: Comable::Deprecator.instance
    deprecate :price, deprecator: Comable::Deprecator.instance
    deprecate :sku_h_item_name, deprecator: Comable::Deprecator.instance
    deprecate :sku_v_item_name, deprecator: Comable::Deprecator.instance
    deprecate :sku_h_choice_name, deprecator: Comable::Deprecator.instance
    deprecate :sku_v_choice_name, deprecator: Comable::Deprecator.instance
  end
end
