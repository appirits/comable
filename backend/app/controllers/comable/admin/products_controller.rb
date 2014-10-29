require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ProductsController < Comable::Admin::ApplicationController
      def index
        @products = Comable::Product.all
      end
    end
  end
end
