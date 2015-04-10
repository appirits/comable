module Comable
  module RequestHelpers
    def sign_in_admin
      before do
        admin = FactoryGirl.create(:user, :admin, password: 'raw_password')
        post comable.admin_user_session_path, 'admin_user[email]' => admin.email, 'admin_user[password]' => admin.password
      end
    end
  end
end
