module Comable
  class Order < ActiveRecord::Base
    belongs_to Comable::Engine::config.customer_table.to_s.singularize.to_sym
    has_many :comable_order_deliveries, dependent: :destroy, class_name: 'Comable::OrderDelivery', foreign_key: 'comable_order_id'

    alias_method :order_deliveries, :comable_order_deliveries

    before_create :generate_code
    after_create :create_order_delivery

    private

    def generate_code
      self.code = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.exists?(code: random_token)
      end
    end

    def create_order_delivery
      customer = self.send(Comable::Engine::config.customer_table.to_s.singularize)
      self.order_deliveries.create(
        family_name: customer.family_name,
        first_name: customer.first_name
      )
    end
  end
end
