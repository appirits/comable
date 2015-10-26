module Comable
  class Product
    module Search
      extend ActiveSupport::Concern

      SEARCH_COLUMNS = %i( name caption )

      module ClassMethods
        def search(query)
          keywords = parse_to_keywords(query)
          return (Rails::VERSION::MAJOR == 3) ? scoped : all if keywords.empty?
          where(keywords_to_arel(keywords))
        end

        private

        def keywords_to_arel(keywords)
          keywords.inject(nil) do |arel_chain, keyword|
            arel = keyword_to_arel(keyword)
            arel_chain ? arel_chain.and(arel) : arel
          end
        end

        def keyword_to_arel(keyword)
          SEARCH_COLUMNS.inject(nil) do |arel_chain, column|
            arel = arel_table[column].matches("%#{keyword}%")
            arel_chain ? arel_chain.or(arel) : arel
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
