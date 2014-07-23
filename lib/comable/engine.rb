require 'slim'
require 'utusemi'

require 'comable/ables/productable'
require 'comable/ables/stockable'
require 'comable/ables/customerable'

module Comable
  class Engine < ::Rails::Engine
    isolate_namespace Comable

    class << self
      def include_comable_module_for(type)
        method_name = "#{type}_class"
        default_class_name = type.to_s.classify

        initializer "comable.initializer.#{type}" do
          class_name = config.send(method_name).to_s if config.respond_to?(method_name)
          class_name ||= default_class_name

          if class_name.safe_constantize
            class_name.constantize.send(:include, "Comable::Able::#{default_class_name}able".constantize)
          end
        end
      end
    end

    include_comable_module_for(:product)
    include_comable_module_for(:stock)
    include_comable_module_for(:customer)
  end
end
