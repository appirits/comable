require_dependency "comable/application_controller"

module Comable
  class Admin::ProductsController < ApplicationController
    def index
      @products = Comable::Product.all
    end
  end
end
