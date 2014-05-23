module Comable
  module ActsAsComableProduct
    module Base
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_comable_product
          Comable.const_set(:Product, self)

          has_many Comable::Stock.model_name.plural.to_sym

          after_create :create_stock

          include InstanceMethods

          require 'comable/product_columns_mapper'
          include Comable::ProductColumnsMapper
        end
      end

      module InstanceMethods
        def unsold?
          stocks.activated.unsold.exists?
        end

        def soldout?
          !unsold?
        end

        private

        def create_stock
          target_stocks = stocks.where(code: code).limit(1)
          target_stocks.create if target_stocks.empty?
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Comable::ActsAsComableProduct::Base
