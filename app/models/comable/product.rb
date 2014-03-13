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
  require 'comable/model_mapper_definition'
  Comable::ModelMapperDefinition.new(:product)
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
