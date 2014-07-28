module Comable
  class Order < ActiveRecord::Base
    include Comable::Able::Orderable
  end
end
