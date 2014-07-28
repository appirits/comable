module Comable
  class Product < ActiveRecord::Base
    include Comable::Decoratable
    include Comable::Able::Productable
  end
end
