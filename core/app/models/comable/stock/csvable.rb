module Comable
  class Stock < ActiveRecord::Base
    module Csvable
      extend ActiveSupport::Concern

      include Comable::Importable

      included do
        comma do
          product_id
          id
          quantity
          sku_h_choice_name
          sku_v_choice_name
        end
      end

      delegate :id, to: :product, prefix: true, allow_nil: true

      def product_id=(id)
        self.product = Comable::Product.find_by(id: id)
      end
    end
  end
end
