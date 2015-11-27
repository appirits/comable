module Comable
  class Product < ActiveRecord::Base
    include Comable::SkuItem
    include Comable::Ransackable
    include Comable::Liquidable
    include Comable::Product::Search
    include Comable::Product::Csvable

    has_many :variants, class_name: Comable::Variant.name, inverse_of: :product, dependent: :destroy
    has_many :images, -> { order(:id) }, class_name: Comable::Image.name, dependent: :destroy
    has_and_belongs_to_many :categories, class_name: Comable::Category.name, join_table: :comable_products_categories

    accepts_nested_attributes_for :variants, allow_destroy: true
    accepts_nested_attributes_for :images, allow_destroy: true

    scope :published, -> (published_at = nil) { where('published_at <= ?', published_at || Time.now) }
    scope :by_newest, -> { reorder(created_at: :desc) }

    validates :name, presence: true, length: { maximum: 255 }

    liquid_methods :id, :code, :name, :price, :images, :image_url

    ransack_options attribute_select: { associations: [:variants, :stocks, :option_types] }

    PREVIEW_SESSION_KEY = :preview_product

    class << self
      def cache_key
        page = all.current_page if all.respond_to? :current_page
        maximum_updated_at = maximum(:updated_at)
        timestamp = maximum_updated_at.utc.to_s(cache_timestamp_format) if maximum_updated_at
        "#{model_name.cache_key}/all-#{[page, timestamp, count].compact.join('-')}"
      end
    end

    def image_url
      image = images.first
      return image.url if image
      'data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/PjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iMTcxIiBoZWlnaHQ9IjE4MCIgdmlld0JveD0iMCAwIDE3MSAxODAiIHByZXNlcnZlQXNwZWN0UmF0aW89Im5vbmUiPjxkZWZzLz48cmVjdCB3aWR0aD0iMTcxIiBoZWlnaHQ9IjE4MCIgZmlsbD0iI0VFRUVFRSIvPjxnPjx0ZXh0IHg9IjU4IiB5PSI5MCIgc3R5bGU9ImZpbGw6I0FBQUFBQTtmb250LXdlaWdodDpib2xkO2ZvbnQtZmFtaWx5OkFyaWFsLCBIZWx2ZXRpY2EsIE9wZW4gU2Fucywgc2Fucy1zZXJpZiwgbW9ub3NwYWNlO2ZvbnQtc2l6ZToxMHB0O2RvbWluYW50LWJhc2VsaW5lOmNlbnRyYWwiPjE3MXgxODA8L3RleHQ+PC9nPjwvc3ZnPg=='
    end

    def stocked?
      variants.any?(&:can_supply?)
    end

    def unstocked?
      !stocked?
    end

    def published?
      published_at.present? && published_at <= Time.now
    end

    def category_path_names=(category_path_names, delimiter: Comable::Category::DEFAULT_PATH_NAME_DELIMITER)
      self.categories = Comable::Category.find_by_path_names(category_path_names, delimiter: delimiter)
    end

    def master?
      option_types.empty?
    end

    def as_json(options = {})
      options[:include] = { variants: { except: :product, methods: [:quantity, :option_names] } }
      super
    end

    def sku_h_item_name
      option_types.first.try(:name)
    end

    def sku_v_item_name
      option_types.second.try(:name)
    end

    def code
      variants.first.try(:sku)
    end

    def code=(code)
      variants.each { |v| v.sku = code }
    end

    def price
      variants.first.try(:price)
    end

    def price=(price)
      variants.each { |v| v.price = price }
    end

    has_many :stocks, class_name: Comable::Stock.name, through: :variants

    def stocks=(stocks)
      stocks.map { |stock| variants.build(stocks: [stock]) }
    end

    def option_types
      variants.map { |variant| variant.option_values.map(&:option_type) }.flatten.uniq
    end

    def option_types_attributes=(_option_types_attributes)
    end

    def properties
      parse_property = JSON.parse(property) # propertyに不正な値が入っていた場合に例外発生する
      return [] unless parse_property.is_a?(Array) && parse_property.all? { |prop| prop.is_a?(Hash) }
      parse_property
    rescue
      []
    end

    #
    # Deprecated methods
    #
    deprecate :stocks, deprecator: Comable::Deprecator.instance
    deprecate :sku_h_item_name, deprecator: Comable::Deprecator.instance
    deprecate :sku_v_item_name, deprecator: Comable::Deprecator.instance
    deprecate :code, deprecator: Comable::Deprecator.instance
    deprecate :code=, deprecator: Comable::Deprecator.instance
    deprecate :option_types_attributes=, deprecator: Comable::Deprecator.instance
  end
end
