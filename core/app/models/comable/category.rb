module Comable
  class Category < ActiveRecord::Base
    has_and_belongs_to_many :products, class_name: Comable::Product.name, join_table: :comable_products_categories
    has_ancestry
    acts_as_list scope: [:ancestry]

    default_scope -> { order('position ASC') }

    after_save :touch_all_products

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
          (category ? category.children : roots).find_by(name: name) || break
        end
      end

      def to_jstree(options = {})
        build_to_jstree(arrange_serializable(order: :position), options).to_json
      end

      def from_jstree!(jstree_json)
        jstree = JSON.parse(jstree_json)

        transaction do
          restore_from_jstree!(jstree)
        end
      end

      private

      def build_to_jstree(serialized_categories, options = {})
        serialized_categories.map do |serialized_category|
          options.merge(
            id: serialized_category['id'],
            text: serialized_category['name'],
            children: build_to_jstree(serialized_category['children'], options)
          )
        end
      end

      def restore_from_jstree!(jstree, parent = nil)
        return unless jstree

        jstree.each.with_index(1) do |node, index|
          return find(node['_destroy']).destroy! if node['_destroy'].present?

          restore_from_jstree_node!(node, parent, position: index)
        end
      end

      def restore_from_jstree_node!(node, parent, default_attributes = {})
        attributes = default_attributes.merge(parent: parent, name: node['text'])
        category = node['id'].to_i.zero? ? new : find(node['id'])
        category.update_attributes!(attributes)

        restore_from_jstree!(node['children'], category)
      end
    end

    def touch_all_products
      products.update_all(updated_at: Time.now)
    end
  end
end
