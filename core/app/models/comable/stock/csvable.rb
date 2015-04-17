module Comable
  class Stock < ActiveRecord::Base
    module Csvable
      extend ActiveSupport::Concern

      include Comable::Importable

      included do
        comma do
          product_code
          code
          quantity
          sku_h_choice_name
          sku_v_choice_name
        end
      end

      delegate :code, to: :product, prefix: true, allow_nil: true

      def product_code=(code)
        return if product_code == code
        self.product = Comable::Product.find_by(code: code)
      end
    end
  end
end
