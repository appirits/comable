module Comable
  module ProductsHelper
    def sku_table(product, options = nil)
      stocks = product.stocks
      content_tag(:table, nil, options) do
        html = ''
        html << build_sku_v_table_header(product, stocks)
        html << build_sku_table_rows(product, stocks)
        html.html_safe
      end
    end

    private

    def build_sku_v_table_header(product, stocks)
      sku_item_name = product.sku_h_item_name
      sku_item_name += '/' + product.sku_v_item_name if product.sku_v?

      html = ''
      html << content_tag(:th, sku_item_name)
      stocks.group_by(&:sku_h_choice_name).keys.each do |sku_h_choice_name|
        next if sku_h_choice_name.blank?
        html << content_tag(:th, sku_h_choice_name)
      end
      html.html_safe
    end

    def build_sku_table_rows(product, stocks)
      return content_tag(:tr, build_sku_table_row(stocks)) unless product.sku_v?

      html = ''
      stocks.group_by(&:sku_v_choice_name).each_pair do |sku_v_choice_name, sku_v_stocks|
        next if sku_v_choice_name.blank?
        html << content_tag(:tr, build_sku_table_row(sku_v_stocks, sku_v_choice_name))
      end
      html.html_safe
    end

    def build_sku_table_row(stocks, sku_v_choice_name = nil)
      html = ''
      html << content_tag(:th, sku_v_choice_name)
      html << stocks.map { |stock| content_tag(:td, build_sku_product_label(stock)) }.join
      html.html_safe
    end

    def build_sku_product_label(stock)
      content_tag(:label) do
        html = ''
        html << radio_button_tag(:stock_id, stock.id, false, disabled: stock.soldout?)
        html << stock.code
        html.html_safe
      end
    end
  end
end
