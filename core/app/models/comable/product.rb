module Comable
  class Product < ActiveRecord::Base
    include Comable::SkuItem
    include Comable::Product::Search

    has_many :stocks, class_name: Comable::Stock.name
    has_and_belongs_to_many :categories, class_name: Comable::Category.name, join_table: :comable_products_categories

    after_create :create_stock

    def unsold?
      stocks.unsold.exists?
    end

    def soldout?
      !unsold?
    end

    private

    def create_stock
      stocks.create(code: code) unless stocks.exists?
    end
  end
end
