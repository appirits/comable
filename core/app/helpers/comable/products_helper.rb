module Comable
  module ProductsHelper
    def listed_categories(categories, options = {})
      content_tag(options[:tag] || :ul, class: options[:class]) do
        categories.map do |category|
          content_tag(:li, link_to_category(category), class: "#{'active' if @category == category}")
        end.join.html_safe
      end
    end

    def link_to_category(category, force_link: false)
      if force_link || @category != category
        link_to category.name, comable.products_path(category_id: category.id)
      else
        category.name
      end
    end

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
        html << content_tag(:th, sku_h_choice_name)
      end
      html.html_safe
    end

    def build_sku_table_rows(product, stocks)
      return content_tag(:tr, build_sku_table_row(stocks)) unless product.sku_v?

      html = ''
      stocks_groups_by_sku_v(stocks).each_pair do |sku_v_choice_name, sku_v_stocks|
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
      return unless stock
      content_tag(:div, class: 'radio') do
        content_tag(:label) do
          html = ''
          html << radio_button_tag(:stock_id, stock.id, false, disabled: stock.unstocked?)
          html << stock.code
          html.html_safe
        end
      end
    end

    def stocks_groups_by_sku_v(stocks)
      sku_h_choice_names = stocks.group_by(&:sku_h_choice_name).keys

      stocks.group_by(&:sku_v_choice_name).each_with_object({}) do |(sku_v_choice_name, sku_v_stocks), group|
        group[sku_v_choice_name] = sku_h_choice_names.map do |sku_h_choice_name|
          sku_v_stocks.find { |s| s.sku_h_choice_name == sku_h_choice_name }
        end
      end
    end
  end
end
