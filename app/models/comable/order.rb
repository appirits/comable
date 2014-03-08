module Comable
  class Order < ActiveRecord::Base
    belongs_to Comable::Engine::config.customer_table.to_s.singularize.to_sym, autosave: false
    has_many :comable_order_deliveries, dependent: :destroy, class_name: 'Comable::OrderDelivery', foreign_key: 'comable_order_id'

    accepts_nested_attributes_for :comable_order_deliveries

    alias_method :order_deliveries, :comable_order_deliveries

    before_create :generate_code
    before_create :assign_default_attributes

    def customer=(customer)
      case customer
      when CustomerSession
        # TODO: クラス変数を利用しないように改善すること
        @@customer_session = customer
      else
        super
      end
    end

    def customer
      super || @@customer_session
    end

    private

    def generate_code
      self.code = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.exists?(code: random_token)
      end
    end

    def assign_default_attributes
      self.family_name ||= customer.family_name
      self.first_name ||= customer.first_name

      self.order_deliveries.build if self.order_deliveries.empty?
      self.order_deliveries.each do |order_delivery|
        order_delivery.customer = customer
      end
    end
  end
end
