module Comable
  module Admin
    class ApplicationController < ActionController::Base
      include Comable::ApplicationHelper

      layout 'comable/admin/application'

      def current_ability
        Comable::Ability.new(current_customer)
      end

      private

      rescue_from CanCan::AccessDenied, with: :unauthorized

      def unauthorized
        if current_customer.signed_in?
          flash[:error] = Comable.t('admin.access_denied')
          redirect_to comable.root_path
        else
          store_location
          redirect_to comable.new_admin_customer_session_path
        end
      end
    end
  end
end
