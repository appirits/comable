module Comable
  module Admin
    class UserSessionsController < Devise::SessionsController
      layout 'comable/admin/application'
    end
  end
end
