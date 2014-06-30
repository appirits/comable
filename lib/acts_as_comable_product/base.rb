module Comable
  module ActsAsComableProduct
    module Base
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_comable_product
          has_many :comable_stocks, class_name: Comable::Stock.model.name

          after_create :create_stock

          include InstanceMethods

          include Comable::ColumnsMapper
        end
      end

      module InstanceMethods
        def stocks
          comable_flag = comable_values[:flag] if respond_to?(:comable_values)
          stocks = comable_stocks
          return if stocks.nil?
          stocks.each { |stock| stock.comable(:stock) } if comable_flag
          stocks
        end

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
