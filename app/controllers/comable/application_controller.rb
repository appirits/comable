module Comable
  class ApplicationController < ActionController::Base
    before_filter :load

    private

    def load
      load_customer
      load_cart
    end

    def load_customer
      @customer = Customer.new(session)
    end

    def load_cart
      @cart = @customer.cart
    end
  end
end
