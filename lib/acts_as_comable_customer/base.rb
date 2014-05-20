module Comable
  module ActsAsComableCustomer
    module Base
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_comable_customer
          Comable.const_set(:Customer, self)

          has_many :comable_orders, class_name: 'Comable::Order'
          alias_method :orders, :comable_orders

          after_initialize :alias_methods_to_comable_customer_accsesor

          include InstanceMethods
        end
      end

      module InstanceMethods
        require 'comable/customer_session'
        require 'comable/cash_register'

        include Comable::CustomerSession

        def logged_in?
          !new_record?
        end

        def not_logged_in?
          !logged_in?
        end

        def add_cart_item(obj)
          case obj
          when Comable::Product
            add_stock_to_cart(obj.stocks.first)
          when Comable::Stock
            add_stock_to_cart(obj)
          when Array
            obj.map { |item| add_cart_item(item) }
          else
            fail
          end
        end

        def remove_cart_item(obj)
          case obj
          when Comable::Stock
            remove_stock_from_cart(obj)
          else
            fail
          end
        end

        def reset_cart
          return super unless self.logged_in?
          cart_items.destroy_all
        end

        def cart_items
          return super unless self.logged_in?
          customer_id = "#{Comable::Customer.model_name.singular}_id"
          Comable::CartItem.where(customer_id => id)
        end

        def cart
          Cart.new(cart_items)
        end

        class Cart < Array
          def price
            stock_key = Comable::Stock.model_name.singular.to_sym
            product_key = Comable::Product.model_name.singular.to_sym
            cart_item_ids = map(&:id)
            Comable::CartItem.includes(stock_key => product_key).where(id: cart_item_ids).to_a.sum(&:price)
          end
        end

        def preorder(order_params = {})
          Comable::CashRegister.new(customer: self, order_attributes: order_params).build_order
        end

        def order(order_params = {})
          Comable::CashRegister.new(customer: self, order_attributes: order_params).create_order
        end

        private

        def add_stock_to_cart(stock)
          return super unless self.logged_in?

          fail if stock.soldout?

          cart_items = find_cart_items_by(stock)
          if cart_items.any?
            cart_item = cart_items.first
            cart_item.increment!(:quantity)
          else
            cart_items.create
          end
        end

        def remove_stock_from_cart(stock)
          return super unless self.logged_in?

          cart_item = find_cart_items_by(stock).first
          return false unless cart_item

          if cart_item.quantity.pred.nonzero?
            cart_item.decrement!(:quantity)
          else
            cart_item.destroy
          end
        end

        def find_cart_items_by(stock)
          return super unless self.logged_in?

          fail unless stock.is_a?(Comable::Stock)

          customer_id = "#{Comable::Customer.model_name.singular}_id"
          stock_id = "#{Comable::Stock.model_name.singular}_id"

          Comable::CartItem.where(customer_id => id, stock_id => stock.id)
        end

        def alias_methods_to_comable_customer_accsesor
          config = Comable::Engine.config
          return unless config.respond_to?(:customer_columns)

          config.customer_columns.each_pair do |column_name, actual_column_name|
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
end

ActiveRecord::Base.send :include, Comable::ActsAsComableCustomer::Base
