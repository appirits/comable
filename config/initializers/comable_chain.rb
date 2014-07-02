module Comable
  module ColumnsMapper
    # 用途
    #   whereなどのArelチェインにおいて、Comable::Engine.config.*_colmunsに設定したマッピングを
    #   意識せずに実装できるよう、デフォルト名による各カラムへのアクセスを可能にする
    #
    # 使用例
    #   Product.comable(:product).where(name: "test")
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

      def comable(obj = nil)
        clone.comable!(obj)
      end

      def comable!(obj = nil)
        obj = true if obj.nil?
        comable_values[:flag] = obj ? true : false
        comable_values[:type] = obj.to_sym if obj.class.in? [Symbol, String]
        warning_checker unless Rails.env.production?
        self
      end

      def build_where(opts = :chain, *rest)
        opts = opts_with_mapped_comable_column_name(opts) if comable_values[:flag]
        super
      end

      def order(opts = nil, *rest)
        opts = opts_with_mapped_comable_column_name(opts) if comable_values[:flag]
        super
      end

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

      def warning_checker
        comable_column_names.each do |old_column_name, new_column_name|
          return if old_column_name != new_column_name
          Rails.logger.warn "[Comable:WARNING] #{old_column_name} is duplicated in Comable::Engine.config.#{comable_values[:type]}_columns."
        end
      end
    end

    # 用途
    #   comableメソッドを利用してレコードを検索した場合は
    #   Comable::ColumnsMapper#comableを個別呼び出さなくても済むようになる
    #
    # 使用例
    #   product = Product.comable(:product).where(name: 'test').first
    #   product.comable(:product).name
    #   #=> 'test' (= products.title)
    #
    #   こうなっていたコードが以下のようになる
    #
    #   product = Product.comable(:product).where(name: 'test').first
    #   product.name
    #   #=> true (= products.title)
    #
    module Relation
      def to_a
        return super unless self.const_defined?(:Comable)
        return super unless Comable.const_defined?(:ColumnsMapper)
        return super unless @klass.include?(Comable::ColumnsMapper)
        return super unless comable_values[:flag]
        super.each { |record| record.comable!(comable_values[:type]) }
      end
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
    module Base
      def initialize(*args, &block)
        case Rails::VERSION::MAJOR
        when 4
          current_scope = self.class.current_scope
        when 3
          current_scope = self.class.scoped
        end
        comable_values = current_scope.try(:comable_values) || {}
        comable!(comable_values[:type]) if self.respond_to?(:comable) && comable_values[:flag]
        super
      end
    end

    # Rails 3.x で scope に対してのカラムマッピングが正常に動作するようにするためのもの
    #
    # 原因
    #   scope 内の条件が unscoped { ... } 内で実行されるため、カラムマッピングを実施する為のフラグが
    #   引き継がれず、カラムマッピングが作動しない
    #
    # 対策
    #   scope メソッドでは unscoped { ... } の結果を Relation.new として再生成しているので
    #   relation メソッドを利用した際にカラムマッピング実施フラグがあればこれを継承するようにした
    #
    module RelationMethod
      def relation(*args, &block)
        return super unless self.respond_to?(:comable)
        return super unless current_scope
        return super unless current_scope.comable_values
        return super unless current_scope.comable_values[:flag]
        super.comable(current_scope.comable_values[:type])
      end
    end
  end
end

module ActiveRecord
  class Relation
    prepend Comable::ColumnsMapper::QueryMethods
    prepend Comable::ColumnsMapper::Relation
  end

  class Base
    class << self
      prepend Comable::ColumnsMapper::Querying
      prepend Comable::ColumnsMapper::RelationMethod if Rails::VERSION::MAJOR == 3
    end
    prepend Comable::ColumnsMapper::Base
  end
end
