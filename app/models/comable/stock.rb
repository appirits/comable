module Comable
  class Stock < ActiveRecord::Base
    include Comable::Able::Stockable
  end
end
