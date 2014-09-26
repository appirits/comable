module Comable
  class Store < ActiveRecord::Base
    class << self
      def instance
        Comable::Store.first || Comable::Store.new(name: default_store_name)
      end

      def default_store_name
        'Comable store'
      end
    end
  end
end
