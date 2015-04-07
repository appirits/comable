module Comable
  #
  # SKU選択肢
  # 商品と注文明細にSKU選択肢としての機能を付与するためのモジュール
  #
  module SkuChoice
    def name_with_sku
      return name unless sku?
      name + "(#{sku_name})"
    end

    def sku_name
      return unless sku?
      sku_name = sku_h_choice_name
      sku_name += '/' + sku_v_choice_name if sku_v_choice_name.present?
      sku_name
    end
  end
end
