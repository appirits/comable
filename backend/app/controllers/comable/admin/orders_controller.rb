require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class OrdersController < Comable::Admin::ApplicationController
      load_and_authorize_resource class: Comable::Order.name, except: :index

      def index
        @q = Comable::Order.complete.ransack(params[:q])
        @orders = @q.result.page(params[:page]).per(15).order('completed_at DESC').accessible_by(current_ability)
      end
    end
  end
end
