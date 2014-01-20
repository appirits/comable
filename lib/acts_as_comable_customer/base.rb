module Comable::ActsAsComableCustomer
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_comable_customer
        include InstanceMethods
      end
    end

    module InstanceMethods
      def initialize(attributes={})
        super
        alias_methods_to_comable_customer_accsesor
      end

      def add_cart(product)
        raise unless product.is_a?(Product)
        cart_item = Comable::CartItem.where(customer_id: self.id, product_id: product.id).first
        if cart_item
          cart_item.update_attributes(quantity: cart_item.quantity.next)
        else
          Comable::CartItem.create(customer_id: self.id, product_id: product.id)
        end
      end

      def cart_items
        Comable::CartItem.where(customer_id: self.id)
      end

      private

      def alias_methods_to_comable_customer_accsesor
        config = Comable::Engine::config
        return unless config.respond_to?(:customer_columns)

        config.customer_default_column_names.each do |column_name|
          actual_column_name = config.customer_columns[column_name]
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

ActiveRecord::Base.send :include, Comable::ActsAsComableCustomer::Base
