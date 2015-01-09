module Comable
  class Product < ActiveRecord::Base
    include Comable::SkuItem

    has_many :stocks, class_name: Comable::Stock.name
    after_create :create_stock

    class << self
      SEARCH_COLUMNS = %i( code name caption )

      def search(query)
        keywords = parse_to_keywords(query)
        return all if keywords.empty?
        all.where(keywords_to_conditions(keywords))
      end

      private

      def keywords_to_conditions(keywords)
        SEARCH_COLUMNS.inject(nil) do |conditions, column|
          keywords_with_percent = keywords.map { |keyword| "%#{keyword}%" }
          condition = arel_table[column].matches_all(keywords_with_percent)
          conditions ? conditions.or(condition) : condition
        end
      end

      def parse_to_keywords(query)
        return [] if query.blank?
        query
          .delete('%')
          .tr('　', ' ')
          .split(' ')
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
