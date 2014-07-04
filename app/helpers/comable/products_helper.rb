module Comable
  module ProductsHelper
    def sku_table(product, options=nil)
      stocks = product.stocks
      sku_h_choice_names = stocks.group_by(&:sku_h_choice_name)
      sku_v_choice_names = stocks.group_by(&:sku_v_choice_name)

      content_tag(:table, nil, options) do
        html = ''

        sku_item_name = product.sku_h_item_name
        sku_item_name += '/' + product.sku_v_item_name if product.has_sku_v_item_name?

        html << content_tag(:th, sku_item_name)
        sku_h_choice_names.keys.each do |sku_h_choice_name|
          next if sku_h_choice_name.blank?
          html << content_tag(:th, sku_h_choice_name)
        end

        if product.has_sku_v_item_name?
          sku_v_choice_names.each_pair do |sku_v_choice_name, stocks|
            next if sku_v_choice_name.blank?
            html << content_tag(:tr, build_sku_v_table(stocks, sku_v_choice_name))
          end
        else
          html << content_tag(:tr, build_sku_v_table(stocks))
        end

        html.html_safe
      end
    end

    private

    def build_sku_v_table(stocks, sku_v_choice_name=nil)
      html = ''
      html << content_tag(:th, sku_v_choice_name)

      stocks.each do |stock|
        html << content_tag(:td) do
          content_tag(:label) do
            label_value = ''
            label_value << radio_button_tag(:stock_id, stock.id, checked=false, disabled: stock.soldout?)
            label_value << stock.code
            label_value.html_safe
          end
        end
      end

      html.html_safe
    end
  end
end
