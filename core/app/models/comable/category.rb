module Comable
  class Category < ActiveRecord::Base
    has_and_belongs_to_many :products, class_name: Comable::Product.name, join_table: :comable_products_categories
    has_ancestry

    DEFAULT_PATH_NAME_DELIMITER = ' > '

    class << self
      def path_names(delimiter: DEFAULT_PATH_NAME_DELIMITER)
        categoris.path(&:name).join(delimiter)
      end

      def find_by_path_names(path_names, delimiter: DEFAULT_PATH_NAME_DELIMITER)
        path_names.map do |path_name|
          find_by_path_name(path_name, delimiter: delimiter)
        end.compact
      end

      def find_by_path_name(path_name, root: nil, delimiter: DEFAULT_PATH_NAME_DELIMITER)
        names = path_name.split(delimiter)
        names.inject(root) do |category, name|
          (category ? category.children : roots).find_by(name: name) || return
        end
      end
    end
  end
end
