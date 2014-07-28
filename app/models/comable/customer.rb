module Comable
  class Customer < ActiveRecord::Base
    include Comable::Able::Customerable
  end
end
