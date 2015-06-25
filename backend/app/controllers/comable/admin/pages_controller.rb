require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class PagesController < Comable::Admin::ApplicationController
      load_and_authorize_resource class: Comable::Page.name, except: :index, find_by: :slug

      def index
        @q = Comable::Page.ransack(params[:q])
        @pages = @q.result.page(params[:page]).accessible_by(current_ability)
      end

      def show
        edit
        render :edit
      end

      def new
      end

      def edit
        set_preview_session
      end

      def create
        @page = Comable::Page.new(page_params)
        @page.slug = @page.normalize_slug(page_params[:slug])

        if @page.save
          redirect_to comable.admin_page_path(@page), notice: Comable.t('successful')
        else
          render :new
        end
      end

      def update
        @page.attributes = page_params
        @page.slug = @page.normalize_slug(page_params[:slug])

        if @page.save
          redirect_to comable.admin_page_path(@page), notice: Comable.t('successful')
        else
          render :edit
        end
      end

      def destroy
        @page.destroy
        redirect_to admin_pages_url, notice: Comable.t('successful')
      end

      private

      def page_params
        params.require(:page).permit(
          :title,            # コンテンツのタイトル
          :content,          # コンテンツ
          :page_title,       # ページのタイトル
          :meta_description, # ディスクリプション
          :meta_keywords,    # キーワード
          :slug,             # スラグ
          :published_at      # 公開日時
        )
      end

      def set_preview_session
        session[Comable::Page::PREVIEW_SESSION_KEY] ||= {}
        session[Comable::Page::PREVIEW_SESSION_KEY][@page.slug] = true
      end
    end
  end
end
