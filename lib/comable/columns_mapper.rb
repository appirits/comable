module Comable
  module ColumnsMapper
    class << self
      def enable
        ::ActiveRecord::Base.send(:include, InstanceMethods)

        ::ActiveRecord::Relation.send(:prepend, ActiveRecord::QueryMethods)
        ::ActiveRecord::Relation.send(:prepend, ActiveRecord::Relation)
        ::ActiveRecord::Base.class_eval { class << self; self; end }.send(:prepend, ActiveRecord::Querying)
        ::ActiveRecord::Base.class_eval { class << self; self; end }.send(:prepend, ActiveRecord::RelationMethod) if Rails::VERSION::MAJOR == 3
        ::ActiveRecord::Base.send(:prepend, ActiveRecord::Base)
        ::ActiveRecord::Base.class_eval { class << self; self; end }.send(:prepend, ActiveRecord::Associations)
      end
    end

    # 用途
    #   モデル向けカラムマッパとインスタンス向けカラムマッパの共通処理
    #
    # 役割
    #   モデル向けカラムマッパ => Comable::ColumnsMapper::ActiveRecord
    #   インスタンス向けカラムマッパ => Comable::ColumnsMapper::InstanceMethods
    #
    module Base
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
        self
      end

      private

      def comable_column_names
        method_name = "#{comable_values[:type]}_columns"
        return {} unless Comable::Engine.config.respond_to?(method_name)
        Comable::Engine.config.send(method_name)
      end

      def mapped_comable_column_name(column_name)
        comable_column_names[column_name.to_sym] || column_name
      end

      def unmapped_comable_column_name(column_name)
        comable_column_names.invert[column_name.to_sym] || column_name
      end

      def eigenclass
        class << self; self; end
      end
    end

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
    module InstanceMethods
      include Base

      def comable!(obj = nil)
        super.tap { comable_columns_mapper if obj.class.in? [Symbol, String] }
      end

      def comable_columns_mapper
        comable_column_names.keys.each do |column_name|
          # alias_attributeと同じことを、対象カラム名を動的に変更して行う
          define_getter_method(column_name)
          define_setter_method(column_name)
          define_predicate_method(column_name)
        end
      end

      def changed
        return super unless comable_values[:flag]
        super + super
          .map { |column_name| unmapped_comable_column_name(column_name) }
          .select { |column_name| comable_column_names[column_name.to_sym] }
      end

      private

      def define_getter_method(column_name)
        target_column_name = mapped_comable_column_name(column_name)
        define_singleton_method(column_name) { send target_column_name }
      end

      def define_setter_method(column_name)
        target_column_name = mapped_comable_column_name(column_name)
        define_singleton_method("#{column_name}=") { |value| send "#{target_column_name}=", value }
      end

      def define_predicate_method(column_name)
        target_column_name = mapped_comable_column_name(column_name)
        define_singleton_method("#{column_name}?") { send "#{target_column_name}?" }
      end
    end

    # 用途
    #   whereなどのArelチェインにおいて、Comable::Engine.config.*_colmunsに設定したマッピングを
    #   意識せずに実装できるよう、デフォルト名による各カラムへのアクセスを可能にする
    #
    # 使用例
    #   Product.comable(:product).where(name: "test")
    #   #=> [<products.titleが"test"であるレコード>]
    #
    module ActiveRecord
      module Querying
        case Rails::VERSION::MAJOR
        when 4
          delegate :comable, to: :all
        when 3
          delegate :comable, to: :scoped
        end
      end

      module QueryMethods
        include Base

        def comable!(obj = nil)
          super.tap { warning_checker unless Rails.env.production? }
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
            key_values = opts.map { |key, value| [mapped_comable_column_name(key.to_s), value] }.flatten(1)
            Hash[*key_values]
          when String, Symbol
            mapped_comable_column_names_for_string(opts.to_s)
          else
            opts
          end
        end

        def mapped_comable_column_names_for_string(string)
          comable_column_names.each do |old_column_name, new_column_name|
            string.gsub!(/\b#{old_column_name}\b/, new_column_name.to_s)
          end
          string
        end

        def warning_checker
          comable_column_names.each do |old_column_name, new_column_name|
            return if old_column_name != new_column_name
            Rails.logger.warn "[Comable:WARNING] #{old_column_name} is duplicated in Comable::Engine.config.#{comable_values[:type]}_columns."
          end
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
          return super unless current_scope
          return super unless current_scope.comable_values
          return super unless current_scope.comable_values[:flag]
          super.comable(current_scope.comable_values[:type])
        end
      end

      module Relation
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
        def to_a
          return super unless comable_values[:flag]
          super.each { |record| record.comable!(comable_values[:type]) }
        end
      end

      module Base
        # 用途
        #   comableメソッドを利用後にレコードを作成した場合は
        #   Comable::ColumnsMapper#comableを個別呼び出さなくても済むようになる
        #
        # 使用例
        #   product = Product.comable(:product).new(name: 'test')
        #   product.name
        #   #=> 'test' (= products.title)
        #
        def initialize(*args, &block)
          case Rails::VERSION::MAJOR
          when 4
            current_scope = self.class.current_scope
          when 3
            current_scope = self.class.scoped
          end
          comable_values = current_scope.try(:comable_values) || {}
          comable!(comable_values[:type]) if comable_values[:flag]
          super
        end
      end

      # 用途
      #   関連モデルにカラムマッパを継承する
      #
      # 使用例
      #   class Product
      #     has_many :stocks, comable: true
      #     ...
      #   end
      #   stock = Product.comable(:product).stocks.first
      #   stock.quantity
      #   #=> 10 (= stocks.units)
      #
      module Associations
        def belongs_to(name, scope = nil, options = {})
          comable_flag = scope.try(:delete, :comable)
          return super unless comable_flag
          super(name, comable_association_scope(:belongs_to, name, scope), options)
          define_comable_association_reader(name, comable_flag => true)
        end

        def has_one(name, scope = nil, options = {})
          comable_flag = scope.try(:delete, :comable)
          return super unless comable_flag
          super(name, comable_association_scope(:has_one, name, scope), options)
          define_comable_association_reader(name, comable_flag => true)
        end

        def has_many(name, scope = nil, options = {}, &extension)
          comable_flag = scope.try(:delete, :comable)
          return super unless comable_flag
          super(name, comable_association_scope(:has_many, name, scope), options, &extension)
          define_comable_association_reader(name, comable_flag => true)
        end

        private

        def comable_association_scope(method_name, name, scope = {})
          association_model = "Comable::#{name.to_s.classify}".constantize
          default_scope = { class_name: association_model.model_name }
          default_scope[:foreign_key] = association_model.foreign_key if method_name == :belongs_to
          default_scope.merge(scope)
        end

        def define_comable_association_reader(name, options = {})
          alias_method "comable_#{name}", name
          define_method name do
            comable_association = send("comable_#{name}")
            return unless comable_association
            comable_flag = comable_values[:flag] || options[:force]
            return comable_association unless comable_flag
            comable_association = comable_association.current_scope if Rails::VERSION::MAJOR == 4 && comable_association.respond_to?(:current_scope)
            comable_association.comable(name.to_s.singularize.to_sym)
          end
        end
      end
    end
  end
end
