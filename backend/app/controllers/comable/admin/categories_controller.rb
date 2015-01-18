require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class CategoriesController < Comable::Admin::ApplicationController
      def index
        @categories = Comable::Category.all.page(params[:page])
      end

      def create
        Comable::Category.from_jstree!(params[:jstree_json])
        redirect_to comable.admin_categories_path
      end
    end
  end
end
