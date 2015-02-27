module Comable
  module Admin
    class UserSessionsController < Devise::SessionsController
      layout 'comable/admin/devise'
    end
  end
end
