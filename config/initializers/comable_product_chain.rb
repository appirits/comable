# -*- coding: utf-8 -*-
module ActiveRecord
  # 用途
  #   whereなどのArelチェインにおいて、Comable::Engine.config.*_colmunsに設定したマッピングを
  #   意識せずに実装できるよう、デフォルト名による各カラムへのアクセスを可能にする
  #
  # 使用例
  #   Comable::Product.comable_product.where(name: "test")
  #   #=> [<products.titleが"test"であるレコード>]
  #
  module Querying
    delegate :comable_product, to: :all
  end

  module QueryMethods
    attr_accessor :comable_product_flag

    def comable_product
      clone = self.clone
      clone.comable_product_flag = true
      clone
    end

    def build_where_with_comable_product(opts = :chain, *rest)
      return build_where_without_comable_product(opts, *rest) if opts == :chain
      return build_where_without_comable_product(opts, *rest) unless comable_product_flag
      build

      build_where_without_comable_product(opts_with_mapped_comable_product_column_name(opts), *rest)
    end
    alias_method_chain :build_where, :comable_product

    def order_with_comable_product(opts = nil, *rest)
      return order_without_comable_product(opts, *rest) if opts.nil?
      return order_without_comable_product(opts, *rest) unless comable_product_mall_no_value

      self.order_without_comable_product(opts_with_mapped_comable_product_column_name(opts), *rest).dup
    end
    alias_method_chain :order, :comable_product

    private

    def opts_with_mapped_comable_product_column_name(opts)
      case opts
      when Hash
        opts.inject(Hash.new) do |result,(key,value)|
          result[mapped_comable_product_column_name(key.to_s)] = value
          result
        end
      when String, Symbol
        mapped_comable_product_column_names(opts.to_s)
      else
        raise
      end
    end

    def mapped_comable_product_column_name(column_name)
      comable_product_column_names[column_name.to_sym] || column_name
    end

    def mapped_comable_product_column_names(comable_product_mall_no, column_names)
      column_names.map { |column_name| mapped_comable_product_column_name(column_name) }
    end

    def comable_product_column_names
      return {} unless Comable::Engine.config.respond_to?(:product_columns)
      Comable::Engine.config.product_columns
    end
  end

  # 用途
  #   comable_productメソッドを利用してレコードを検索した場合は
  #   Comable::ProductColumnsMapper#comable_productを個別呼び出さなくても済むようになる
  #
  # 使用例
  #   product = Product.comable_product.where(name: 'test').first
  #   product.comable_product
  #   product.name
  #   #=> 'test' (= products.title)
  #
  #   こうなっていたコードが以下のようになる
  #
  #   product = Product.comable_product.where(name: 'test').first
  #   product.name
  #   #=> true (= products.title)
  #
  class Relation
    # TODO: 初回呼び出し時に失敗する
    #   ex.)
    #
    #   % rails console
    #   irb> Comable::Product
    #   => Product (call 'Product.connection' to establish a connection)
    #   irb> exit
    #
    #   % rails console
    #   irb> Comable::Product.new.name
    #   => NoMethodError: undefined method `name' for #<Product:...>
    #   irb> Comable::Product.new.name
    #   => nil
    #
    def new_with_comable_product(*args, &block)
      return new_without_comable_product unless self.const_defined?(:Comable)
      return new_without_comable_product unless Comable.const_defined?(:ProductColumnsMapper)
      return new_without_comable_product unless @klass.include?(Comable::ProductColumnsMapper)
      return new_without_comable_product unless comable_product_flag
      new_without_comable_product(*args, &block).tap { |instance| instance.comable_product }
    end
    alias_method_chain :new, :comable_product
  end
end
