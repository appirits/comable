require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ThemesController < Comable::Admin::ApplicationController
      load_and_authorize_resource class: Comable::Theme.name, find_by: :name

      def index
        @themes = @themes.by_newest
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
        @theme.dir.rmtree if @theme.dir.exist?
        redirect_to comable.admin_themes_path, notice: Comable.t('successful')
      end

      def tree
        render :show_file
      end

      def show_file
        @code = filepath.read if filepath.try(:file?)
      end

      def update_file
        save_file
        redirect_to comable.file_admin_theme_path(@theme, path: params[:path]), notice: Comable.t('successful')
      rescue => e
        @code = params[:code]
        flash.now[:alert] = e.message
        render :show_file
      end

      def use
        current_store.update_attributes!(theme: @theme)
        redirect_to :back, notice: Comable.t('successful')
      end

      private

      def save_file
        # Validate the Liquid syntax
        Liquid::Template.parse(params[:code])

        filepath.dirname.mkpath unless filepath.dirname.exist?
        filepath.write(params[:code])
      end

      def filepath
        return unless params[:path]
        @theme.dir + params[:path]
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
