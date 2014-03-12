module Comable
  class Order < ActiveRecord::Base
    belongs_to Comable::Customer.table_name.singularize.to_sym, class_name: Comable::Customer.origin_class.name
    has_many :comable_order_deliveries, dependent: :destroy, class_name: 'Comable::OrderDelivery', foreign_key: 'comable_order_id'

    accepts_nested_attributes_for :comable_order_deliveries

    alias_method :order_deliveries, :comable_order_deliveries

    validates :family_name, presence: true
    validates :first_name, presence: true

    before_create :generate_code

    alias_method :customer_orgin, Comable::Customer.table_name.singularize.to_sym

    def customer
      if Comable::Customer.mapping?
        Comable::Customer.new(self.customer_orgin)
      else
        self.customer_orgin
      end
    end

    private

    def generate_code
      self.code = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.exists?(code: random_token)
      end
    end
  end
end
