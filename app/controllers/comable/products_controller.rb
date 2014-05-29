module Comable
  class ProductsController < ApplicationController
    def index
      @products = Comable::Product.all
    end

    def show
      @product = Comable::Product.find(params[:id])
    end
  end
end
