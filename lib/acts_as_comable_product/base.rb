module Comable
  module ActsAsComableProduct
    module Base
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_comable_product
          has_many :stocks, class_name: Comable::Stock.model_name

          after_create :create_stock

          include InstanceMethods
        end
      end

      module InstanceMethods
        def unsold?
          stocks.activated.unsold.exists?
        end

        def soldout?
          !unsold?
        end

        def sku_h?
          sku_h_item_name.present?
        end

        def sku_v?
          sku_v_item_name.present?
        end

        alias_method :sku?, :sku_h?

        private

        def create_stock
          product = utusemi(:product)
          stocks = product.stocks
          stocks.create(code: product.code) unless stocks.exists?
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Comable::ActsAsComableProduct::Base
