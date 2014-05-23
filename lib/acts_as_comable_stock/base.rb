module Comable
  module ActsAsComableStock
    module Base
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_comable_stock
          Comable.const_set(:Stock, self)

          belongs_to Comable::Product.model_name.singular.to_sym

          after_initialize :alias_methods_to_comable_stock_accsesor

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

        private

        def alias_methods_to_comable_stock_accsesor
          config = Comable::Engine.config
          return unless config.respond_to?(:stock_columns)

          config.stock_columns.each_pair do |column_name, actual_column_name|
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

ActiveRecord::Base.send :include, Comable::ActsAsComableStock::Base
