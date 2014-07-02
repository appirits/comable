module Comable
  class Order < ActiveRecord::Base
    belongs_to :customer, class_name: Comable::Customer.model_name, foreign_key: Comable::Customer.foreign_key, autosave: false
    has_many :comable_order_deliveries, dependent: :destroy, class_name: 'Comable::OrderDelivery', foreign_key: 'comable_order_id'

    accepts_nested_attributes_for :comable_order_deliveries

    alias_method :order_deliveries, :comable_order_deliveries

    validates :family_name, presence: true
    validates :first_name, presence: true

    before_create :generate_code

    private

    def generate_code
      self.code = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.exists?(code: random_token)
      end
    end
  end
end
