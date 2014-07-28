module Comable
  class Stock < ActiveRecord::Base
    include Comable::Decoratable
    include Comable::Able::Stockable
  end
end
