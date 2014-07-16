module Comable
  class CartItem < ActiveRecord::Base
    belongs_to :customer, utusemi: :force, class_name: Comable::Customer.model_name, foreign_key: Comable::Customer.foreign_key
    belongs_to :stock, utusemi: :force, class_name: Comable::Stock.model_name, foreign_key: Comable::Stock.foreign_key

    validates Comable::Customer.foreign_key, uniqueness: { scope: [Comable::Customer.foreign_key, Comable::Stock.foreign_key] }

    delegate :product, to: :stock

    def price
      stock.price * quantity
    end
  end
end
