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
    case Rails::VERSION::MAJOR
    when 4
      delegate :comable, to: :all
    when 3
      delegate :comable, to: :scoped
    end
  end

  module QueryMethods
    def comable_values
      @comable_values ||= {}
    end

    def comable(type)
      comable_values[:type] = type
      comable_values[:flag] = true
      self
    end

    def build_where_with_comable(opts = :chain, *rest)
      return build_where_without_comable(opts, *rest) if opts == :chain
      return build_where_without_comable(opts, *rest) unless comable_values[:flag]

      build_where_without_comable(opts_with_mapped_comable_column_name(opts), *rest)
    end
    alias_method_chain :build_where, :comable

    def order_with_comable(opts = nil, *rest)
      return order_without_comable(opts, *rest) if opts.nil?
      return order_without_comable(opts, *rest) unless comable_values[:flag]

      order_without_comable(opts_with_mapped_comable_column_name(opts), *rest).dup
    end
    alias_method_chain :order, :comable

    private

    def opts_with_mapped_comable_column_name(opts)
      case opts
      when Hash
        key_values = opts.map { |key, value| [mapped_comable_column_name(key.to_s), value] }.flatten
        Hash[*key_values]
      when String, Symbol
        mapped_comable_column_names_for_string(opts.to_s)
      else
        opts
      end
    end

    def mapped_comable_column_name(column_name)
      comable_column_names[column_name.to_sym] || column_name
    end

    def mapped_comable_column_names_for_string(string)
      comable_column_names.each do |old_column_name, new_column_name|
        string.gsub!(/\b#{old_column_name}\b/, new_column_name.to_s)
      end
      string
    end

    def comable_column_names
      method_name = "#{comable_values[:type]}_columns"
      return {} unless Comable::Engine.config.respond_to?(method_name)
      Comable::Engine.config.send(method_name)
    end
  end

  # 用途
  #   comableメソッドを利用してレコードを検索した場合は
  #   Comable::ColumnsMapper#comableを個別呼び出さなくても済むようになる
  #
  # 使用例
  #   product = Product.comable(:product).where(name: 'test').first
  #   product.comable_product
  #   product.name
  #   #=> 'test' (= products.title)
  #
  #   こうなっていたコードが以下のようになる
  #
  #   product = Product.comable(:product).where(name: 'test').first
  #   product.name
  #   #=> true (= products.title)
  #
  # TODO
  #   初回呼び出し時に失敗する
  #   ex.)
  #     % rails console
  #     irb> Comable::Product
  #     => Product (call 'Product.connection' to establish a connection)
  #     irb> exit
  #
  #     % rails console
  #     irb> Comable::Product.new.name
  #     => NoMethodError: undefined method `name' for #<Product:...>
  #     irb> Comable::Product.new.name
  #     => nil
  #
  class Relation
    def to_a_with_comable
      return to_a_without_comable unless self.const_defined?(:Comable)
      return to_a_without_comable unless Comable.const_defined?(:ColumnsMapper)
      return to_a_without_comable unless @klass.include?(Comable::ColumnsMapper)
      return to_a_without_comable unless comable_values[:flag]
      to_a_without_comable.each { |record| record.comable(comable_values[:type]) }
    end
    alias_method_chain :to_a, :comable

    # for Rails 3
    alias_method :model, :klass if Rails::VERSION::MAJOR == 3
  end

  # 用途
  #   comableメソッドを利用後にレコードを作成した場合は
  #   Comable::ColumnsMapper#comableを個別呼び出さなくても済むようになる
  #
  # 使用例
  #   product = Product.comable(:product).new(name: 'test')
  #   product.name
  #   #=> 'test' (= products.title)
  #
  # TODO
  #   初回呼び出し時に失敗する
  #
  class Base
    def initialize_with_comable(*args, &block)
      case Rails::VERSION::MAJOR
      when 4
        current_scope = self.class.current_scope
      when 3
        current_scope = self.class.scoped
      end
      comable_values = current_scope.try(:comable_values) || {}
      comable(comable_values[:type]) if self.respond_to?(:comable) && comable_values[:flag]
      initialize_without_comable(*args, &block)
    end
    alias_method_chain :initialize, :comable
  end
end
