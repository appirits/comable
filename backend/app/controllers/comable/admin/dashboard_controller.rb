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
        # @this_month_users = Comable::User.with_role(:user).this_month
        # @this_week_users = Comable::User.with_role(:user).this_week
        # @last_week_users = Comable::User.with_role(:user).last_week
        # authorize! :read, @this_week_users
      end
    end
  end
end
