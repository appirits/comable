module Comable
  module Linkable
    extend ActiveSupport::Concern

    module ClassMethods
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
        # HACK: Rails3系のpluckでは複数フィールドを指定できないためselectとmapでカラムを取得する
        # options = pluck(*linkable_columns(:name, :id))
        columns = linkable_columns(:name, :id)
        records = select(columns)
        options = records.map(&columns.first).zip(records.map(&columns.last))
        @use_index ? options.unshift(index_option) : options
      end

      def linkable_exists?
        @use_index || exists?
      end

      private

      def default_columns_key
        {
          id: :id,
          name: :name
        }
      end

      def index_option
        [Comable.t('admin.actions.index'), nil]
      end
    end
  end
end
