module Comable
  class PagesController < Comable::ApplicationController
    def show
      if Rails::VERSION::MAJOR == 3
        @page = Comable::Page.find(params[:id])
      else
        @page = Comable::Page.friendly.find(params[:id])
      end
      fail ActiveRecord::RecordNotFound unless @page && (@page.published? || preview?)
    end

    private

    def preview?
      session[Comable::Page::PREVIEW_SESSION_KEY] ||= {}
      session[Comable::Page::PREVIEW_SESSION_KEY][@page.slug]
    end
  end
end
