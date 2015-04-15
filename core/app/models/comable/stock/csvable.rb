module Comable
  class Stock < ActiveRecord::Base
    module Csvable
      extend ActiveSupport::Concern

      included do
        comma do
          product :name
          code
          quantity
          sku_h_choice_name
          sku_v_choice_name
        end
      end
    end
  end
end
