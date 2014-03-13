# TODO: 別ファイル化
if not Comable::Engine::config.respond_to?(:customer_table)
  class Comable::Customer < ActiveRecord::Base
    acts_as_comable_customer

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
  class Comable::Customer
    include Comable::ActsAsComableCustomer::Base
    acts_as_comable_customer(mapping_flag: false)

    attr_reader :origin

    class << self
      def origin_class
        Comable::Engine::config.customer_table.to_s.classify.constantize
      end

      def method_missing(method_name, *args, &block)
        self.origin_class.send(method_name, *args, &block)
      end
    end

    def initialize(*args)
      obj = args.first
      case obj
      when self.class.origin_class
        @origin = obj
      else
        @origin = self.class.origin_class.new(*args)
        super
      end
    end

    def method_missing(method_name, *args, &block)
      self.origin.send(method_name, *args, &block)
    end
  end
end

module Comable
  class Customer
    class << self
      def mapping?
        self.origin_class != self
      end
    end
  end
end
