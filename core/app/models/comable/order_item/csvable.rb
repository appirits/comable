module Comable
  class OrderItem < ActiveRecord::Base
    module Csvable
      extend ActiveSupport::Concern

      included do
        comma do
          __association__ order: :code
          __association__ order: :email
          __association__ order: :payment_fee
          __association__ order: :shipment_fee
          __association__ order: :total_price
          __association__ order: { bill_address: :family_name }
          __association__ order: { bill_address: :first_name }
          __association__ order: { bill_address: :zip_code }
          __association__ order: { bill_address: :state_name }
          __association__ order: { bill_address: :city }
          __association__ order: { bill_address: :detail }
          __association__ order: { bill_address: :phone_number }
          name
          sku
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
