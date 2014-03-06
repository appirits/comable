module Comable
  class Order < ActiveRecord::Base
    belongs_to Comable::Engine::config.customer_table.to_s.singularize.to_sym
    has_many :comable_order_deliveries, dependent: :destroy, class_name: 'Comable::OrderDelivery', foreign_key: 'comable_order_id'

    accepts_nested_attributes_for :comable_order_deliveries

    alias_method :order_deliveries, :comable_order_deliveries

    before_create :generate_code
    before_create :assign_default_attributes

    private

    def generate_code
      self.code = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.exists?(code: random_token)
      end
    end

    def assign_default_attributes
      self.order_deliveries.build if self.order_deliveries.empty?
    end
  end
end
