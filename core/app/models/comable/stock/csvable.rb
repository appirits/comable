module Comable
  class Stock < ActiveRecord::Base
    module Csvable
      extend ActiveSupport::Concern

      include Comable::Importable

      included do
        comma do
          __association__ product: :code
          __association__ product: :name
          code
          quantity
          sku_h_choice_name
          sku_v_choice_name
        end
      end
    end
  end
end
