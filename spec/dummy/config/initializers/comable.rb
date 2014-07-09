module Comable
  class Engine < ::Rails::Engine
    config.product_table = :products
    config.customer_table = :customers
    config.stock_table = :stocks

    Utusemi.configure do
      map :product do
        name :title
      end

      map :stock do
        quantity :units
      end
    end
  end
end
