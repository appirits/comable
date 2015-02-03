module Comable
  class Product < ActiveRecord::Base
    include Comable::SkuItem
    include Comable::Product::Search

    has_many :stocks, class_name: Comable::Stock.name, dependent: :destroy
    has_many :images, class_name: Comable::Image.name, dependent: :destroy
    has_and_belongs_to_many :categories, class_name: Comable::Category.name, join_table: :comable_products_categories

    accepts_nested_attributes_for :images, allow_destroy: true

    after_create :create_stock

    paginates_per 15

    validates :name, presence: true, length: { maximum: 255 }
    validates :code, presence: true, length: { maximum: 255 }
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
    validates :sku_h_item_name, length: { maximum: 255 }
    validates :sku_v_item_name, length: { maximum: 255 }

    # Add conditions for the images association.
    # Override method of the images association to support Rails 3.x.
    def images
      super.order(:id)
    end

    def image_url
      image = images.first
      return image.url if image
      'data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/PjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iMTcxIiBoZWlnaHQ9IjE4MCIgdmlld0JveD0iMCAwIDE3MSAxODAiIHByZXNlcnZlQXNwZWN0UmF0aW89Im5vbmUiPjxkZWZzLz48cmVjdCB3aWR0aD0iMTcxIiBoZWlnaHQ9IjE4MCIgZmlsbD0iI0VFRUVFRSIvPjxnPjx0ZXh0IHg9IjU4IiB5PSI5MCIgc3R5bGU9ImZpbGw6I0FBQUFBQTtmb250LXdlaWdodDpib2xkO2ZvbnQtZmFtaWx5OkFyaWFsLCBIZWx2ZXRpY2EsIE9wZW4gU2Fucywgc2Fucy1zZXJpZiwgbW9ub3NwYWNlO2ZvbnQtc2l6ZToxMHB0O2RvbWluYW50LWJhc2VsaW5lOmNlbnRyYWwiPjE3MXgxODA8L3RleHQ+PC9nPjwvc3ZnPg=='
    end

    def unsold?
      stocks.unsold.exists?
    end

    def soldout?
      !unsold?
    end

    def category_path_names=(category_path_names, delimiter: Comable::Category::DEFAULT_PATH_NAME_DELIMITER)
      self.categories = Comable::Category.find_by_path_names(category_path_names, delimiter: delimiter)
    end

    private

    def create_stock
      stocks.create(code: code) unless stocks.exists?
    end
  end
end
