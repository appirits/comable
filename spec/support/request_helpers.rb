module Comable
  module RequestHelpers
    def sign_in_admin
      before do
        admin = FactoryGirl.create(:customer, :admin, password: 'raw_password')
        post comable.admin_customer_session_path, 'admin_customer[email]' => admin.email, 'admin_customer[password]' => admin.password
      end
    end
  end
end
