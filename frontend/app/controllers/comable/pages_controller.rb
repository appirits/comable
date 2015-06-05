module Comable
  class PagesController < Comable::ApplicationController
    def show
      @page = Comable::Page.find_by(slug: params[:slug])
      fail unless @page && (@page.opened? || preview?)
    end

    private

    def preview?
      session[Comable::Page::PREVIEW_SESSION_KEY] ||= {}
      session[Comable::Page::PREVIEW_SESSION_KEY][@page.slug]
    end
  end
end
