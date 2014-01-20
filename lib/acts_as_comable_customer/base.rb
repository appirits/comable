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

      def add_cart(obj)
        case obj
        when Product
          add_cart_by_product(obj)
        when Array
          obj.map {|product| add_cart_by_product(product) }
        end
      end

      def cart_items
        Comable::CartItem.where(customer_id: self.id)
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

      def add_cart_by_product(product)
        raise unless product.is_a?(Product)
        cart_items = Comable::CartItem.where(customer_id: self.id, product_id: product.id)
        if cart_items.any?
          cart_item = cart_items.first
          cart_item.update_attributes(quantity: cart_item.quantity.next)
        else
          cart_items.create
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
