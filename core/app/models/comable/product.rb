module Comable
  class Product < ActiveRecord::Base
    include Comable::SkuItem

    has_many :stocks, class_name: Comable::Stock.name, foreign_key: table_name.singularize.foreign_key
    after_create :create_stock

    def unsold?
      stocks.activated.unsold.exists?
    end

    def soldout?
      !unsold?
    end

    private

    def create_stock
      stocks.create(code: code) unless stocks.exists?
    end
  end
end
