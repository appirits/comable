module Comable
  class Product < ActiveRecord::Base
    include Comable::SkuItem

    has_many :stocks, class_name: Comable::Stock.name
    after_create :create_stock

    def unsold?
      stocks.unsold.exists?
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
