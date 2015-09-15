module Comable
  class ProductsController < Comable::ApplicationController
    before_filter :load_category_and_products, only: :index

    def index
      @products = @products.page(params[:page]).per(Comable::Config.products_per_page)
    end

    def show
      @product = preview? ? Comable::Product.find(params[:id]) : Comable::Product.published.find(params[:id])
    end

    private

    def load_category_and_products
      @category = Comable::Category.where(id: params[:category_id]).first
      if @category
        subtree_of_category = Comable::Category.subtree_of(@category)
        @products = Comable::Product.published.eager_load(:categories).merge(subtree_of_category)
      else
        @products = Comable::Product.published.search(params[:q])
      end
    end

    def preview?
      session[Comable::Product::PREVIEW_SESSION_KEY] ||= {}
      session[Comable::Product::PREVIEW_SESSION_KEY][params[:id]]
    end
  end
end
