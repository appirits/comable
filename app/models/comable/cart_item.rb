module Comable
  class CartItem < ActiveRecord::Base
    belongs_to Comable::Customer.table_name.singularize.to_sym, class_name: Comable::Customer.origin_class.name
    belongs_to Comable::Product.table_name.singularize.to_sym, class_name: Comable::Product.origin_class.name

    validates "#{Comable::Customer.table_name.singularize}_id", uniqueness: { scope: "#{Comable::Customer.table_name.singularize}_id" }

    alias_method :customer_orgin, Comable::Customer.table_name.singularize.to_sym
    alias_method :product_orgin, Comable::Product.table_name.singularize.to_sym

    def customer
      if Comable::Customer.mapping?
        Comable::Customer.new(self.customer_orgin)
      else
        self.customer_orgin
      end
    end

    def product
      if Comable::Product.mapping?
        Comable::Product.new(self.product_orgin)
      else
        self.product_orgin
      end
    end

    def price
      self.product.price * self.quantity
    end
  end
end
