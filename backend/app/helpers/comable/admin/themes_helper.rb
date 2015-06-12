module Comable
  module Admin
    module ThemesHelper
      def editable?
        params[:path].present?
      end

      def display_directory_tree(tree, dirpath = nil)
        content_tag(:dl, build_directory_tree(tree, dirpath))
      end

      private

      def build_directory_tree(tree, dirpath)
        entries = tree.values.first
        entries.map do |entry|
          if entry.is_a? Hash
            build_directory_tree_children(dirpath, entry)
          else
            build_directory_tree_child(dirpath, entry)
          end
        end.join.html_safe
      end

      def build_directory_tree_children(dirpath, entry)
        dirname = entry.keys.first.to_s
        path = dirpath ? File.join(dirpath, dirname) : dirname
        content_tag(:dt, dirname) + display_directory_tree(entry, path)
      end

      def build_directory_tree_child(dirpath, filename)
        path = File.join(dirpath, filename)
        link = link_to(filename, comable.file_admin_theme_path(path: path))
        content_tag(:dd, link)
      end
    end
  end
end
