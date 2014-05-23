module Comable
  module ProductColumnsMapper
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
    #             include ProductColumnsMapper
    #             ...
    #
    #   product = Comable::Product.first
    #   product.name
    #   #=> NoMethodError: undefined method `name' for #<Product:...>
    #
    #   product.comable_product.name
    #   #=> 'test product'
    #
    included do
      def comable_product(comable_product_column_mapping_flag = true)
        return true if @comable_product_column_mapping_flag

        extend ClassMethods
        comable_product_columns_mapper

        @comable_product_column_mapping_flag = comable_product_column_mapping_flag
      end

      def mapped_comable_product_column_name(column_name)
        return column_name unless @comable_product_column_mapping_flag
        self.class.comable_product_column_names[column_name.to_sym] || column_name
      end

      def unmapped_comable_product_column_name(column_name)
        return column_name unless @comable_product_column_mapping_flag
        self.class.comable_product_column_names.invert[column_name.to_sym] || column_name
      end

      def changed_with_comable_product_colums
        return changed_without_comable_product_colums unless @comable_product_column_mapping_flag
        changed_without_comable_product_colums + changed_for_mapped_comable_product_colums
      end
      alias_method_chain :changed, :comable_product_colums

      private

      def changed_for_mapped_comable_product_colums
        changed_without_comable_product_colums.
          map {|column_name| unmapped_comable_product_column_name(column_name) }.
          select {|column_name| self.class.comable_product_column_names[column_name.to_sym] }
      end
    end

    module ClassMethods
      def comable_product_columns_mapper
        comable_product_column_names.each_pair do |column_name,_|
          # alias_attributeと同じことを、対象カラム名を動的に変更して行う
          class_eval <<-EOS
            def #{column_name}
              target_column_name = mapped_comable_product_column_name('#{column_name}')
              self.send target_column_name
            end

            def #{column_name}=(value)
              target_column_name = mapped_comable_product_column_name('#{column_name}')
              self.send target_column_name + '=', value
            end

            def #{column_name}?
              target_column_name = mapped_product_column_name('#{column_name}')
              self.send target_column_name + '?'
            end
          EOS
        end
      end

      def comable_product_column_names
        return {} unless Comable::Engine.config.respond_to?(:product_columns)
        Comable::Engine.config.product_columns
      end
    end
  end
end
