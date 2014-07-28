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

    class << self
      def include_comable_able_module_for(type)
        method_name = "#{type}_class"
        default_class_name = type.to_s.classify

        initializer "comable.initializer.#{type}" do
          class_name = config.send(method_name).to_s if config.respond_to?(method_name)
          class_name ||= default_class_name

          klass = class_name.safe_constantize
          next unless klass

          comable_able_module = "Comable::Able::#{default_class_name.gsub(/[ey]$/, '')}able".constantize
          klass.send(:include, comable_able_module)
        end
      end
    end

    include_comable_able_module_for(:product)
    include_comable_able_module_for(:stock)
    include_comable_able_module_for(:customer)
    include_comable_able_module_for(:order)
    include_comable_able_module_for(:order_delivery)
    include_comable_able_module_for(:order_detail)

    # refs: http://edgeguides.rubyonrails.org/engines.html#overriding-models-and-controllers
    config.to_prepare do
      Dir.glob(Rails.root + 'app/decorators/comable/*_decorator*.rb').each do |c|
        require_dependency(c)
      end
    end
  end
end
