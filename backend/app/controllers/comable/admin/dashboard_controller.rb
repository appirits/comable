require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class DashboardController < Comable::Admin::ApplicationController
      def show
        @this_month_orders = Comable::Order.this_month
        @this_week_orders = Comable::Order.this_week
        @last_week_orders = Comable::Order.last_week
        authorize! :read, @this_month_orders

        # TODO: Comment out after adding timestamp columns
        # @this_month_customers = Comable::Customer.with_role(:customer).this_month
        # @this_week_customers = Comable::Customer.with_role(:customer).this_week
        # @last_week_customers = Comable::Customer.with_role(:customer).last_week
        # authorize! :read, @this_week_customers
      end
    end
  end
end
