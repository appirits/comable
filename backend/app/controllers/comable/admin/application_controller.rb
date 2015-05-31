module Comable
  module Admin
    class ApplicationController < ActionController::Base
      include Comable::ApplicationHelper

      # Include `asset_path` method for gritter
      helper Sprockets::Helpers::RailsHelper if Rails::VERSION::MAJOR == 3

      layout 'comable/admin/application'

      def current_ability
        Comable::Ability.new(current_comable_user)
      end

      def respond_to_export_with(records)
        respond_to do |format|
          format.csv do
            render csv: records, filename: filename
          end

          format.xlsx do
            render xlsx: 'export', filename: filename, locals: { records: records }, template: 'comable/admin/shared/export', layout: false
          end
        end
      end

      private

      rescue_from CanCan::AccessDenied, with: :unauthorized

      def unauthorized
        if current_comable_user.signed_in?
          flash[:alert] = Comable.t('admin.access_denied')
          redirect_to after_access_denied_path
        else
          store_location
          redirect_to comable.new_admin_user_session_path
        end
      end

      def after_access_denied_path
        if current_comable_user.customer?
          comable.root_path
        else
          comable.admin_root_path
        end
      end

      def filename
        "#{timestamp}_#{controller_name}"
      end

      def timestamp
        Time.now.strftime('%Y%m%d%H%M%S')
      end
    end
  end
end
