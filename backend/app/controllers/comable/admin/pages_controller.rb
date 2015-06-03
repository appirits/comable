require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class PagesController < Comable::Admin::ApplicationController
      load_and_authorize_resource class: Comable::Page.name, except: :index

      def index
        @q = Comable::Page.ransack(params[:q])
        @pages = @q.result(distinct: true).page(params[:page]).accessible_by(current_ability)
      end

      def show
        render :edit
      end

      def new
      end

      def edit
      end

      def create
        @page = Comable::Page.new(page_params)

        if @page.save
          redirect_to comable.admin_page_path(@page), notice: Comable.t('successful')
        else
          render :new
        end
      end

      def update
        if @page.update_attributes(page_params)
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
    end
  end
end
