module Comable
  module AuthorizationHelpers
    module Controller
      def sign_in_admin(options = {})
        before do
          @request.env['devise.mapping'] = Devise.mappings[:admin_user]
          admin = create(:user, :admin, options)
          sign_in :admin_user, admin
        end
      end
    end

    module Feature
      class << self
        def extended(base)
          base.send(:include, Warden::Test::Helpers)
        end
      end

      def authorization!(scope = :user)
        before do
          user = (scope.to_sym == :admin_user) ? create(:user, :admin) : create(:user)
          login_as(user, scope: scope)
        end
      end
    end
  end
end
