module Comable
  class Category < ActiveRecord::Base
    has_and_belongs_to_many :products, class_name: Comable::Product.name, join_table: :comable_products_categories
    has_ancestry
  end
end
