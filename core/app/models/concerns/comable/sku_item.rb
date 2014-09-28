module Comable
  #
  # SKU項目
  # 商品と注文明細にSKU項目としての機能を付与するためのモジュール
  #
  module SkuItem
    def sku_h?
      sku_h_item_name.present?
    end

    def sku_v?
      sku_v_item_name.present?
    end

    alias_method :sku?, :sku_h?
  end
end
