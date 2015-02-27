module Comable
  #
  # 在庫モデル。
  # 商品に複数紐付き、品数やSKU(Stock Keeping Unit)情報を保持する。
  #
  class Stock < ActiveRecord::Base
    include Comable::SkuItem
    include Comable::SkuChoice

    belongs_to :product, class_name: Comable::Product.name

    #
    # @!group Scope
    #

    # @!scope class
    # 品切れでない在庫インスタンスを返す
    scope :unsold, -> { where('quantity > ?', 0) }

    # @!scope class
    # 品切れの在庫インスタンスを返す
    scope :soldout, -> { where('quantity <= ?', 0) }

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

    class << self
      def ransackable_attributes(auth_object = nil)
        column_names + _ransackers.keys - %w(product_id)
      end
    end

    # 在庫の有無を取得する
    #
    # @example
    #   stock.unsold? #=> true
    #
    # @param quantity [Fixnum] 減算する在庫数を指定する
    # @return [Boolean] 在庫があれば true を返す
    # @see #soldout?
    def unsold?(quantity: 1)
      (self.quantity - quantity) >= 0
    end

    # 在庫の有無を取得する
    #
    # @example
    #   stock.soldout? #=> false
    #
    # @param quantity [Fixnum] 減算する在庫数を指定する
    # @return [Boolean] {#unsold?} の逆。在庫がなければ true を返す
    # @see #unsold?
    def soldout?(quantity: 1)
      !unsold?(quantity: quantity)
    end
  end
end
