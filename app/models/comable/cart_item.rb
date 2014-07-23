module Comable
  class CartItem < ActiveRecord::Base
    utusemi!

    belongs_to :customer, class_name: Comable::Customer.name, foreign_key: Comable::Customer.name.foreign_key
    belongs_to :stock, class_name: Comable::Stock.name, foreign_key: Comable::Stock.name.foreign_key

    validates Comable::Customer.name.foreign_key, uniqueness: { scope: [Comable::Customer.name.foreign_key, Comable::Stock.name.foreign_key] }

    delegate :product, to: :stock

    def price
      stock.price * quantity
    end
  end
end
