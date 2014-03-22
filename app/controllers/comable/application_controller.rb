module Comable
  class ApplicationController < ActionController::Base
    before_filter :load

    def logged_in_customer
      # Please override this method for logged in customer
    end

    private

    def load
      load_customer
      load_cart
    end

    def load_customer
      @customer = logged_in_customer
      @customer ||= Comable::Customer.new(session)
    end

    def load_cart
      @cart = @customer.cart
    end
  end
end
