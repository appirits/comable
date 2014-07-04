module Comable
  module ActsAsComableProduct
    module Base
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_comable_product
          has_many :comable_stocks, class_name: Comable::Stock.model_name

          after_create :create_stock

          include InstanceMethods
        end
      end

      module InstanceMethods
        def stocks
          return comable_stocks unless comable_values[:flag]
          stocks = comable_stocks
          return if stocks.nil?
          stocks = stocks.current_scope if Rails::VERSION::MAJOR == 4
          stocks.comable(:stock)
        end

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
          target_stocks = stocks.where(code: code).limit(1)
          target_stocks.create if target_stocks.empty?
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Comable::ActsAsComableProduct::Base
