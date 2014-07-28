module Comable
  class Product < ActiveRecord::Base
    include Decoratable

    has_many :stocks, class_name: Comable::Stock.name, foreign_key: table_name.singularize.foreign_key
    after_create :create_stock

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
      stocks.create(code: code) unless stocks.exists?
    end
  end
end
