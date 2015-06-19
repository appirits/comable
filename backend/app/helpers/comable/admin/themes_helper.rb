module Comable
  module Admin
    module ThemesHelper
      def editable?
        params[:path].present?
      end

      def display_directory_tree(tree, dirpath = nil)
        content_tag(:dl, build_directory_tree(tree, dirpath))
      end

      def liquidable_models
        Comable.constants.map do |constant|
          klass = "Comable::#{constant}".constantize
          klass.constants.include?(:LiquidDropClass) ? klass : nil
        end.compact
      end

      private

      def build_directory_tree(tree, dirpath)
        entries = tree.values.first
        entries.map do |entry|
          if entry.is_a? Hash
            build_directory_tree_children(entry, dirpath)
          else
            build_directory_tree_child(entry, dirpath)
          end
        end.join.html_safe
      end

      def build_directory_tree_children(entry, dirpath)
        dirname = entry.keys.first.to_s
        path = dirpath ? File.join(dirpath, dirname) : dirname
        content_tag(:dt, dirname) + display_directory_tree(entry, path)
      end

      def build_directory_tree_child(filename, dirpath)
        path = File.join(dirpath, filename)
        link = link_to(filename, comable.file_admin_theme_path(@theme, path: path))
        content_tag(:dd, link)
      end
    end
  end
end
