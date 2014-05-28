module Comable
  module ActsAsComableStock
    module Base
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_comable_stock
          Comable.const_set(:Stock, comable(:stock))

          belongs_to Comable::Product.model_name.singular.to_sym

          scope :activated, -> { where.not(comable_column_name[:product_id_num] => nil) }
          scope :unsold, -> { where("#{comable_column_name[:quantity]} > ?", 0) }
          scope :soldout, -> { where("#{comable_column_name[:quantity]} <= ?", 0) }

          delegate :price, to: Comable::Product.model_name.singular.to_sym

          include InstanceMethods
        end

        def comable_column_name
          default_columns = { product_id: :product_id, product_id_num: :product_id_num, code: :code, quantity: :quantity }
          return default_columns unless Comable::Engine.config.respond_to?(:stock_columns)
          default_columns.merge(Comable::Engine.config.stock_columns)
        end
      end

      module InstanceMethods
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
            decrement!(self.class.comable_column_name[:quantity])
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Comable::ActsAsComableStock::Base
