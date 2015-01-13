module Comable
  class ProductsController < Comable::ApplicationController
    def index
      @category = Comable::Category.where(id: params[:category_id]).first
      if @category
        subtree_of_category = Comable::Category.subtree_of(@category)
        @products = Comable::Product.eager_load(:categories).merge(subtree_of_category)
      else
        @products = Comable::Product.search(params[:q])
      end
      @products = @products.page(params[:page])
    end

    def show
      @product = Comable::Product.find(params[:id])
    end
  end
end
