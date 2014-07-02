module Comable
  module ActsAsComableStock
    module Base
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_comable_stock
          belongs_to :comable_product, class_name: Comable::Product.model.name, foreign_key: Comable::Product.foreign_key

          scope :activated, -> { where.not(product_id_num: nil) }
          scope :unsold, -> { where('quantity > ?', 0) }
          scope :soldout, -> { where('quantity <= ?', 0) }

          delegate :price, to: :product

          include InstanceMethods

          include Comable::ColumnsMapper
        end
      end

      module InstanceMethods
        def product
          comable_flag = comable_values[:flag] if respond_to?(:comable_values)
          product = comable_product
          return if product.nil?
          product.comable(:product) if comable_flag
          product
        end

        def unsold?
          return false if product_id_num.nil?
          return false if quantity.nil?
          quantity > 0
        end

        def soldout?
          !unsold?
        end

        def decrement_quantity!
          ActiveRecord::Base.transaction do
            # TODO: カラムマッピングのdecrementメソッドへの対応
            update_attributes(quantity: quantity.pred)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Comable::ActsAsComableStock::Base
