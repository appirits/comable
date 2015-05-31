module Comable
  class HomeController < Comable::ApplicationController
    before_filter :load_products, only: :show

    def show
    end

    private

    def load_products
      @products = Comable::Product.limit(5)
    end
  end
end
