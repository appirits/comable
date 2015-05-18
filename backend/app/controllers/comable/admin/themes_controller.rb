require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ThemesController < Comable::Admin::ApplicationController
      def index
      end

      def show
        params[:id] ||= 'default'
        @code = File.open("themes/#{params[:id]}/comable/products/index.slim").read
      end

      def update
        params[:id] ||= 'default'
        @code = params[:code]
        render :show
      end
    end
  end
end
