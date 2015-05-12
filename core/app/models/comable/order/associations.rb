module Comable
  class Order < ActiveRecord::Base
    module Associations
      extend ActiveSupport::Concern

      included do
        belongs_to :user, class_name: Comable::User.name, autosave: false
        belongs_to :bill_address, class_name: Comable::Address.name, autosave: true, dependent: :destroy
        belongs_to :ship_address, class_name: Comable::Address.name, autosave: true, dependent: :destroy
        has_many :order_items, dependent: :destroy, class_name: Comable::OrderItem.name, inverse_of: :order
        has_one :payment, dependent: :destroy, class_name: Comable::Payment.name, inverse_of: :order
        has_one :shipment, dependent: :destroy, class_name: Comable::Shipment.name, inverse_of: :order

        accepts_nested_attributes_for :bill_address
        accepts_nested_attributes_for :ship_address
        accepts_nested_attributes_for :order_items
        accepts_nested_attributes_for :payment
        accepts_nested_attributes_for :shipment
      end
    end
  end
end
