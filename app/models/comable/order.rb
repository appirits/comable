module Comable
  class Order < ActiveRecord::Base
    include Decoratable

    belongs_to :customer, class_name: Comable::Customer.name, foreign_key: Comable::Customer.table_name.singularize.foreign_key, autosave: false
    has_many :order_deliveries, dependent: :destroy, class_name: Comable::OrderDelivery.name, foreign_key: table_name.singularize.foreign_key

    accepts_nested_attributes_for :order_deliveries

    validates :family_name, presence: true
    validates :first_name, presence: true

    before_create :generate_code
    before_create :generate_ordered_at

    private

    def generate_code
      self.code = loop do
        random_token = "C#{Array.new(11) { rand(9) }.join}"
        break random_token unless self.class.exists?(code: random_token)
      end
    end

    def generate_ordered_at
      self.ordered_at = Time.now
    end
  end
end
