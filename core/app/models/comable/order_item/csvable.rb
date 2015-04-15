module Comable
  class OrderItem < ActiveRecord::Base
    module Csvable
      extend ActiveSupport::Concern

      included do
        klass = self
        comma do
          order :code
          order :email
          order :shipment_fee
          order :total_price
          klass.comma_nested_attribute(self, order: { bill_address: :family_name })
          klass.comma_nested_attribute(self, order: { bill_address: :first_name })
          klass.comma_nested_attribute(self, order: { bill_address: :zip_code })
          klass.comma_nested_attribute(self, order: { bill_address: :state_name })
          klass.comma_nested_attribute(self, order: { bill_address: :city })
          klass.comma_nested_attribute(self, order: { bill_address: :detail })
          klass.comma_nested_attribute(self, order: { bill_address: :phone_number })
          name
          code
          price
          sku_h_item_name
          sku_v_item_name
          sku_h_choice_name
          sku_v_choice_name
          quantity
        end
      end
    end
  end
end
