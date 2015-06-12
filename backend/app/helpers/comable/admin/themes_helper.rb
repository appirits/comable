module Comable
  module Admin
    module ThemesHelper
      def display_directory_tree(tree, parent = nil)
        key, value = tree.first
        value.map do |entry|
          if entry.is_a? Hash
            parent_key, _ = entry.first
            content_tag(:dt, parent_key) + display_directory_tree(entry, File.join(parent.to_s, parent_key.to_s))
          else
            fullpath = File.join(parent, entry)
            link = link_to(entry, comable.file_admin_theme_path(path: fullpath))
            content_tag(:dd, link)
          end
        end.join.html_safe
      end
    end
  end
end
