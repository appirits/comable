module Comable
  #
  # 在庫モデル。
  # 商品に複数紐付き、品数やSKU(Stock Keeping Unit)情報を保持する。
  #
  class Stock < ActiveRecord::Base
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

    # TODO: add conditions (by limitless flag, backoder flag and etc..)
    validates :quantity, numericality: { greater_than_or_equal_to: 0 }

    delegate :name, to: :product
    delegate :price, to: :product
    delegate :sku?, to: :product

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
