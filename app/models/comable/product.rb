# TODO: 別ファイル化
if not Comable::Engine::config.respond_to?(:product_table)
  class Comable::Product < ActiveRecord::Base
    acts_as_comable_product

    class << self
      def origin_class
        self
      end
    end

    def origin
      self
    end
  end
else
  class Comable::Product
    include Comable::ActsAsComableProduct::Base
    acts_as_comable_product(mapping_flag: false)

    attr_reader :origin

    class << self
      def origin_class
        Comable::Engine::config.product_table.to_s.classify.constantize
      end

      def method_missing(method_name, *args, &block)
        result = self.origin_class.send(method_name, *args, &block)
        case result
        when self.origin_class
          self.new(result)
        when Array
          result.map {|obj| self.new(obj) }
        when ActiveRecord::Relation
          ActiveRecord::Relation.new(self, result.arel_table)
        else
          result
        end
      end
    end

    def initialize(*args)
      obj = args.first
      case obj
      when self.class.origin_class
        @origin = obj
      else
        @origin = self.class.origin_class.new(*args)
      end
    end

    def method_missing(method_name, *args, &block)
      self.origin.send(method_name, *args, &block)
    end

    def ==(product)
      if product.respond_to?(:origin)
        self.origin == product.origin
      else
        self.origin == product
      end
    end
  end
end

module Comable
  class Product
    class << self
      def mapping?
        self.origin_class != self
      end
    end
  end
end
