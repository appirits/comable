module Comable
  module ApplicationHelper
    def current_customer
      @current_customer || load_customer
    end

    private

    def load_customer
      @current_customer = logged_in_customer
      @current_customer ||= Customer.new(session)
    end

    def logged_in_customer
      # Please override this method for logged in customer
    end
  end
end
