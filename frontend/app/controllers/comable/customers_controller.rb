module Comable
  class CustomersController < Comable::ApplicationController
    before_filter :authenticate_customer!

    def show
    end
  end
end
