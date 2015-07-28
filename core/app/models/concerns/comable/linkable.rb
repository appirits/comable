module Comable
  module Linkable
    extend ActiveSupport::Concern

    module ClassMethods
      attr_reader :_linkable_columns, :use_index

      def linkable_columns_keys(options = {})
        if options.present?
          @_linkable_columns = default_columns_key.merge(options.slice(:name, :id))
          @use_index = options[:use_index]
        else
          @_linkable_columns
        end
      end

      def linkable_columns(*key)
        (@_linkable_columns || default_columns_key).slice(*key).values
      end

      def linkable_id_options
        options = pluck(*linkable_columns(:name, :id))
        @use_index ? options.unshift([]) : options
      end

      private

      def default_columns_key
        {
          id: :id,
          name: :name
        }
      end
    end
  end
end
