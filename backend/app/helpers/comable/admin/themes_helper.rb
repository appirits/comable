module Comable
  module Admin
    module ThemesHelper
      def editable?
        params[:path].present?
      end

      def display_views_directory_tree
        views_direcotry_tree = load_directory_tree(views_dir)
        build_directory_tree(views_direcotry_tree)
      end

      def liquidable_models
        Comable.constants.map do |constant|
          klass = "Comable::#{constant}".constantize
          klass.constants.include?(:LiquidDropClass) ? klass : nil
        end.compact
      end

      private

      def views_dir
        spec = Gem::Specification.find_by_name('comable-frontend')
        fail 'Please install "comable-frontend" gem!' unless spec
        "#{spec.gem_dir}/app/views"
      end

      def load_directory_tree(path, parent = nil)
        children = []
        tree = { (parent || :root) => children }

        Dir.foreach(path) do |entry|
          next if entry.start_with? '.'
          fullpath = File.join(path, entry)
          children << (File.directory?(fullpath) ? load_directory_tree(fullpath, entry.to_sym) : entry.sub(/\..+$/, '.liquid'))
        end

        tree
      end

      def build_directory_tree(tree, dirpath = nil)
        content_tag(:dl, build_directory_tree_nodes(tree, dirpath))
      end

      def build_directory_tree_nodes(tree, dirpath)
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
        content_tag(:dt, dirname) + build_directory_tree(entry, path)
      end

      def build_directory_tree_child(filename, dirpath)
        path = File.join(dirpath, filename)
        link = link_to(filename, comable.file_admin_theme_path(@theme, path: path))
        content_tag(:dd, link)
      end
    end
  end
end
