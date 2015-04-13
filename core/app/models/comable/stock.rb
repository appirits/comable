module Comable
  #
  # 在庫モデル。
  # 商品に複数紐付き、品数やSKU(Stock Keeping Unit)情報を保持する。
  #
  class Stock < ActiveRecord::Base
    include Comable::SkuItem
    include Comable::SkuChoice
    include Comable::Ransackable

    belongs_to :product, class_name: Comable::Product.name

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

    validates :product, presence: true
    validates :code, presence: true, length: { maximum: 255 }
    validates :sku_h_choice_name, length: { maximum: 255 }
    validates :sku_v_choice_name, length: { maximum: 255 }
    # TODO: add conditions (by limitless flag, backoder flag and etc..)
    validates :quantity, numericality: { greater_than_or_equal_to: 0 }

    delegate :name, to: :product
    delegate :price, to: :product
    delegate :sku_h_item_name, to: :product
    delegate :sku_v_item_name, to: :product

    ransack_options attribute_select: { associations: :product }, ransackable_attributes: { except: :product_id }

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
  end
end
