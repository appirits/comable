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
  end
end
