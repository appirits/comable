module Comable
  class Engine < ::Rails::Engine
    config.product_class = :DummyProduct
    config.customer_class = :Customer
    config.stock_class = :Stock

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
