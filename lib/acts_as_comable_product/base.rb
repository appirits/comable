module Comable::ActsAsComableProduct
  module Base
    extend ActiveSupport::Concern

    included do
      attr_accessor :hoge
    end

    module ClassMethods
      def acts_as_comable_product
        define_method :initialize do
          raise
        end
      end
    end
  end
end

::ActiveRecord::Base.send :include, ::Comable::ActsAsComableProduct::Base
