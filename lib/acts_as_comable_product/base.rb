module Comable::ActsAsComableProduct
  module Base
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_comable_product(options={})
        default_options = { mapping_flag: true }
        options = default_options.merge(options)

        if options[:mapping_flag]
          after_initialize :alias_methods_to_comable_product_accsesor
        end

        include InstanceMethods
      end
    end

    module InstanceMethods
      private

      def alias_methods_to_comable_product_accsesor
        config = Comable::Engine::config
        return unless config.respond_to?(:product_columns)

        config.product_columns.each_pair do |column_name,actual_column_name|
          next if actual_column_name.blank?
          next if actual_column_name == column_name

          class_eval do
            alias_attribute column_name, actual_column_name
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Comable::ActsAsComableProduct::Base
