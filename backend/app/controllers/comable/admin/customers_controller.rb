require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class CustomersController < Comable::Admin::ApplicationController
      before_filter :find_customer, only: [:show, :edit, :update, :destroy]

      def index
        @customers = Comable::Customer.page(params[:page])
        @customers = @customers.where!('email LIKE ?', "%#{params[:search_email]}%") if params[:search_email].present?
      end

      private

      def find_customer
        @customer = Comable::Customer.find(params[:id])
      end
    end
  end
end
