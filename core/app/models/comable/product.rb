module Comable
  class Product < ActiveRecord::Base
    include Comable::SkuItem

    has_many :stocks, class_name: Comable::Stock.name
    after_create :create_stock

    class << self
      def search(keyword)
        keyword.to_s.delete!('%')
        return all if keyword.blank?

        code = arel_table[:code].matches("%#{keyword}%")
        name = arel_table[:name].matches("%#{keyword}%")
        caption = arel_table[:caption].matches("%#{keyword}%")

        relation = all
        relation.where!(code.or(name.or(caption)))
        relation
      end
    end

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
