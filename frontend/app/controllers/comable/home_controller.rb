module Comable
  class HomeController < Comable::ApplicationController
    before_filter :load_products, only: :show

    def show
    end

    private

    def load_products
      @products = Comable::Product.includes(:images, :variants).limit(4)
    end
  end
end
