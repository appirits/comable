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
  require 'comable/model_mapper_definition'
  Comable::ModelMapperDefinition.new(:customer)
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
