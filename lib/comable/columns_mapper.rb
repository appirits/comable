module Comable
  module ColumnsMapper
    extend ActiveSupport::Concern

    # 用途
    #   Comable::Engine.config.*_colmunsに設定したマッピングを意識せずに
    #   実装できるよう、デフォルト名による各カラムへのアクセスを可能にする
    #
    # 使用例
    #   module Comable
    #     module ActsAsComableProduct
    #       module Base
    #         module ClassMethods
    #           def acts_as_comable_product
    #             ...
    #             include ColumnsMapper
    #             ...
    #
    #   product = Product.first
    #   product.name
    #   #=> NoMethodError: undefined method `name' for #<Product:...>
    #
    #   product.comable(:product).name
    #   #=> 'test product'
    #
    included do
      def comable_values
        @comable_values ||= {}
      end

      def comable(obj = nil)
        clone.comable!(obj)
      end

      def comable!(obj = nil)
        obj = true if obj.nil?
        comable_values[:flag] = obj ? true : false
        comable_values[:type] = obj.to_sym if obj.class.in? [Symbol, String]
        comable_columns_mapper if obj.class.in? [Symbol, String]
        self
      end

      def comable_columns_mapper
        comable_column_names.keys.each do |column_name|
          # alias_attributeと同じことを、対象カラム名を動的に変更して行う
          define_getter_method(column_name)
          define_setter_method(column_name)
          define_predicate_method(column_name)
        end
      end

      def mapped_comable_column_name(column_name)
        return column_name unless comable_values[:flag]
        comable_column_names[column_name.to_sym] || column_name
      end

      def unmapped_comable_column_name(column_name)
        return column_name unless comable_values[:flag]
        comable_column_names.invert[column_name.to_sym] || column_name
      end

      def changed_with_comable_colums
        return changed_without_comable_colums unless comable_values[:flag]
        changed_without_comable_colums + changed_for_mapped_comable_colums
      end
      alias_method_chain :changed, :comable_colums

      private

      def changed_for_mapped_comable_colums
        changed_without_comable_colums
          .map { |column_name| unmapped_comable_column_name(column_name) }
          .select { |column_name| comable_column_names[column_name.to_sym] }
      end

      def comable_column_names
        method_name = "#{comable_values[:type]}_columns"
        return {} unless Comable::Engine.config.respond_to?(method_name)
        Comable::Engine.config.send(method_name)
      end

      def define_getter_method(column_name)
        class_eval <<-EOS
          def #{column_name}
            target_column_name = mapped_comable_column_name('#{column_name}').to_s
            self.send target_column_name
          end
        EOS
      end

      def define_setter_method(column_name)
        class_eval <<-EOS
          def #{column_name}=(value)
            target_column_name = mapped_comable_column_name('#{column_name}').to_s
            self.send target_column_name + '=', value
          end
        EOS
      end

      def define_predicate_method(column_name)
        class_eval <<-EOS
          def #{column_name}?
            target_column_name = mapped_column_name('#{column_name}').to_s
            self.send target_column_name + '?'
          end
        EOS
      end
    end
  end
end
