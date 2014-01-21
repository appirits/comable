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

      def add_cart_item(obj)
        case obj
        when ::Comable::Engine::config.product_table.to_s.classify.constantize
          add_product(obj)
        when Array
          obj.map {|product| add_product(product) }
        else
          raise
        end
      end

      def remove_cart_item(obj)
        case obj
        when ::Comable::Engine::config.product_table.to_s.classify.constantize
          remove_product(obj)
        else
          raise
        end
      end

      def cart_items
        customer_id = "#{::Comable::Engine::config.customer_table.to_s.singularize}_id"
        Comable::CartItem.where(customer_id => self.id)
      end

      def cart
        Cart.new(cart_items)
      end

      class Cart < Array
        def price
          self.sum(&:price)
        end
      end

      private

      def add_product(product)
        raise unless product.is_a?(::Comable::Engine::config.product_table.to_s.classify.constantize)

        customer_id = "#{::Comable::Engine::config.customer_table.to_s.singularize}_id"
        product_id = "#{::Comable::Engine::config.product_table.to_s.singularize}_id"

        cart_items = Comable::CartItem.where(customer_id => self.id, product_id => product.id)
        if cart_items.any?
          cart_item = cart_items.first
          cart_item.update_attributes(quantity: cart_item.quantity.next)
        else
          cart_items.create
        end
      end

      def remove_product(product)
        raise unless product.is_a?(::Comable::Engine::config.product_table.to_s.classify.constantize)

        customer_id = "#{::Comable::Engine::config.customer_table.to_s.singularize}_id"
        product_id = "#{::Comable::Engine::config.product_table.to_s.singularize}_id"

        cart_item = Comable::CartItem.where(customer_id => self.id, product_id => product.id).first
        return false unless cart_item

        cart_item.quantity = cart_item.quantity.pred
        if cart_item.quantity.nonzero?
          cart_item.save
        else
          cart_item.destroy
        end
      end

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
