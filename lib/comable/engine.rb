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

    # refs: http://edgeguides.rubyonrails.org/engines.html#overriding-models-and-controllers
    config.to_prepare do
      Dir.glob(Rails.root + 'app/decorators/comable/*_decorator*.rb').each do |c|
        require_dependency(c)
      end
    end
  end
end
