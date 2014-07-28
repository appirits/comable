module Comable
  class OrderDelivery < ActiveRecord::Base
    include Comable::Able::OrderDeliverable
  end
end
