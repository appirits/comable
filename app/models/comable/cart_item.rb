module Comable
  class CartItem < ActiveRecord::Base
    belongs_to :customer, class_name: Comable::Customer.name, foreign_key: Comable::Customer.table_name.singularize.foreign_key
    belongs_to :stock, class_name: Comable::Stock.name, foreign_key: Comable::Stock.table_name.singularize.foreign_key

    with_options if: :customer do |customer|
      customer.validates Comable::Customer.table_name.singularize.foreign_key, uniqueness: { scope: [Comable::Customer.table_name.singularize.foreign_key, Comable::Stock.table_name.singularize.foreign_key] }
      customer.validates Comable::Customer.table_name.singularize.foreign_key, presence: true
    end

    with_options if: :guest_token do |guest|
      guest.validates :guest_token, uniqueness: { scope: [:guest_token, Comable::Stock.table_name.singularize.foreign_key] }
      guest.validates :guest_token, presence: true
    end

    delegate :product, to: :stock

    before_create :generate_guest_token

    def price
      stock.price * quantity
    end

    private

    def generate_guest_token
      return if send(Comable::Customer.table_name.singularize.foreign_key)
      self.guest_token ||= loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.exists?(guest_token: random_token)
      end
    end
  end
end
