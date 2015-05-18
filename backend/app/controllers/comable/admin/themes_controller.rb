require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ThemesController < Comable::Admin::ApplicationController
      before_filter :load_directory_tree, only: :show

      def index
      end

      def show
        params[:id] ||= 'default'
        @code = File.read(filepath) if filepath && File.exist?(filepath)
      end

      def update
        params[:id] ||= 'default'

        File.write(filepath, params[:code])

        redirect_to comable.admin_theme_path(id: params[:id], path: params[:path])
      end

      private

      def filepath
        return unless params[:path]
        File.join("themes/#{params[:id]}/comable", params[:path])
      end

      def load_directory_tree
        @directory_tree = directory_tree("themes/#{params[:id]}/comable")
      end

      def directory_tree(path, parent = nil)
        children = []
        tree = { (parent || :root)  => children }

        Dir.foreach(path) do |entry|
          next if entry.in? ['..', '.']
          fullpath = File.join(path, entry)

          if File.directory?(fullpath)
            children << directory_tree(fullpath, entry.to_sym)
          else
            children << entry
          end
        end

        tree
      end
    end
  end
end
