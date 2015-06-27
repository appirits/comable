module Comable
  module Admin
    class UserSessionsController < Devise::SessionsController
      helper Comable::Admin::ApplicationHelper
      layout 'comable/admin/application'
    end
  end
end
