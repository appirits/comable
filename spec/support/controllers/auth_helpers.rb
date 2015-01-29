module Comable
  module AuthHelpers
    def sign_in_admin
      before do
        @request.env['devise.mapping'] = Devise.mappings[:customer]
        admin = FactoryGirl.create(:customer, :admin)
        sign_in :customer, admin
      end
    end
  end
end
