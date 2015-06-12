require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ThemesController < Comable::Admin::ApplicationController
      load_and_authorize_resource class: Comable::Theme.name, find_by: :name

      before_filter :load_directory_tree, only: [:tree, :show_file]

      def index
      end

      def show
        render :edit
      end

      def new
        @theme.attributes = {
          version: @theme.default_version,
          author: current_comable_user.bill_full_name || current_comable_user.email
        }
      end

      def create
        if @theme.save
          FileUtils.mkdir_p(theme_dir)
          redirect_to comable.admin_theme_path(@theme), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def edit
      end

      def update
        if @theme.update_attributes(theme_params)
          redirect_to comable.admin_theme_path(@theme), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      def destroy
        @theme.destroy
        FileUtils.rm_rf(theme_dir)
        redirect_to comable.admin_themes_path, notice: Comable.t('successful')
      end

      def tree
        render :show_file
      end

      def show_file
        @code = File.read(filepath) if filepath && File.exist?(filepath)
      end

      def update_file
        File.write(filepath, params[:code])
        redirect_to comable.file_admin_theme_path(@theme, path: params[:path]), notice: Comable.t('successful')
        # TODO: Add this code
        # rescue => e
        #   @code = params[:code]
        #   flash.now[:alert] = e.message
        #   render :show_file
      end

      private

      def theme_dir
        "themes/#{@theme.name}/comable"
      end

      def filepath
        return unless params[:path]
        File.join(theme_dir, params[:path])
      end

      def load_directory_tree
        @directory_tree = directory_tree(theme_dir)
      end

      def directory_tree(path, parent = nil)
        children = []
        tree = { (parent || :root)  => children }

        Dir.foreach(path) do |entry|
          next if entry.in? %w( .. . )
          fullpath = File.join(path, entry)
          children << (File.directory?(fullpath) ? directory_tree(fullpath, entry.to_sym) : entry)
        end

        tree
      end

      def theme_params
        params.require(:theme).permit(
          :name,
          :version,
          :display,
          :homepage,
          :author
        )
      end
    end
  end
end
