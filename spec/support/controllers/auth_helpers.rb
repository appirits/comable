module Comable
  module AuthHelpers
    def sign_in_admin(options = {})
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        admin = create(:user, :admin, options)
        sign_in :user, admin
      end
    end
  end
end
