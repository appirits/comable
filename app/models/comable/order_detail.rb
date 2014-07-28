module Comable
  class OrderDetail < ActiveRecord::Base
    include Comable::Able::OrderDetailable
  end
end
