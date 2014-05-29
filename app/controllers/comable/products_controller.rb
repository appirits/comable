module Comable
  class ProductsController < ApplicationController
    def index
      @products = Comable::Product::Mapper.all
    end

    def show
      @product = Comable::Product::Mapper.find(params[:id])
    end
  end
end
