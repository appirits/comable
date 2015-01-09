module Comable
  class Product
    module Search
      extend ActiveSupport::Concern

      SEARCH_COLUMNS = %i( code name caption )

      module ClassMethods
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
    end
  end
end
