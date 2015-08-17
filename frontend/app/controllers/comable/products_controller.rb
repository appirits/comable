module Comable
  class ProductsController < Comable::ApplicationController
    before_filter :load_category_and_products, only: :index

    def index
      @products = @products.page(params[:page]).per(Comable::Config.products_per_page)
    end

    def show
      @product = Comable::Product.find(params[:id])
      fail ActiveRecord::RecordNotFound unless @product.published?
    end

    private

    def load_category_and_products
      @category = Comable::Category.where(id: params[:category_id]).first
      if @category
        subtree_of_category = Comable::Category.subtree_of(@category)
        @products = Comable::Product.eager_load(:categories).merge(subtree_of_category)
      else
        @products = Comable::Product.search(params[:q])
      end
    end
  end
end
