module Comable
  module AuthHelpers
    def sign_in_admin
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        admin = FactoryGirl.create(:user, :admin)
        sign_in :user, admin
      end
    end
  end
end
