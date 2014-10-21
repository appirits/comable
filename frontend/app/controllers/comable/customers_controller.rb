module Comable
  class CustomersController < Comable::ApplicationController
    before_filter :authenticate_member!

    def show
    end
  end
end
