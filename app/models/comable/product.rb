module Comable
  class Product < ActiveRecord::Base
    include Comable::Able::Productable
  end
end
