module Comable
  module Linkable
    extend ActiveSupport::Concern

    module ClassMethods
      private

      def calc_linkable_id_options(klass, column_options = {})
        return [[]] unless klass
        # HACK: Rails3系のpluckでは複数フィールドを指定できないためselectとmapでカラムを取得する
        # options = klass.pluck(*linkable_columns(column_options))
        select_columns = linkable_columns(column_options)
        records = klass.select(select_columns)
        options = records.map(&select_columns.first).zip(records.map(&select_columns.last))

        column_options[:use_index] ? options.unshift(index_option) : options
      end

      def linkable_columns(column_keys)
        default_columns_key.merge(column_keys).slice(:name, :id).values
      end

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
