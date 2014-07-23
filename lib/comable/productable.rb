module Comable
  module Productable
    def self.included(base)
      base.instance_eval do
        has_many :stocks, class_name: Comable::Stock.name
        after_create :create_stock
      end
    end

    def unsold?
      stocks.activated.unsold.exists?
    end

    def soldout?
      !unsold?
    end

    def sku_h?
      sku_h_item_name.present?
    end

    def sku_v?
      sku_v_item_name.present?
    end

    alias_method :sku?, :sku_h?

    private

    def create_stock
      product = utusemi(:product)
      stocks = product.stocks
      stocks.create(code: product.code) unless stocks.exists?
    end
  end
end
