require 'slim'
require 'utusemi'

require 'comable/ables/productable'
require 'comable/ables/stockable'
require 'comable/ables/customerable'
require 'comable/ables/orderable'
require 'comable/ables/order_deliverable'
require 'comable/ables/order_detailable'

module Comable
  class Engine < ::Rails::Engine
    isolate_namespace Comable
  end
end
