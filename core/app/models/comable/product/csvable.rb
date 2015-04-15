module Comable
  class Product < ActiveRecord::Base
    module Csvable
      extend ActiveSupport::Concern

      included do
        comma do
          name
          code
          price
          caption
          sku_h_item_name
          sku_v_item_name
        end
      end
    end
  end
end
