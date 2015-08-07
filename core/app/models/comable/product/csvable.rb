module Comable
  class Product < ActiveRecord::Base
    module Csvable
      extend ActiveSupport::Concern

      include Comable::Importable

      included do
        comma do
          name
          code
          price
          caption
          published_at
          sku_h_item_name
          sku_v_item_name
        end
      end
    end
  end
end
