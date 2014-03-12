module Comable
  class TableDefinition
    def initialize(migration)
      @migration = migration
    end

    def change_table
      if mapping?
        yield self
      else
        @migration.create_table table_name do |t|
          yield t
        end
      end
    end

    COLUMN_TYPES = %w( string text integer datetime )

    COLUMN_TYPES.each do |column_type|
      define_method column_type do |column_name, options={}|
        add_column(column_name, column_type, options)
      end
    end

    private

    def type
      case @migration.class.name
      when /Product/
        :product
      when /Customer/
        :customer
      end
    end

    def mapping?
      Comable::Engine::config.respond_to?("#{type}_table")
    end

    def table_name
      if mapping?
        Comable::Engine::config.send("#{type}_table")
      else
        "comable_#{type.to_s.pluralize}"
      end
    end

    def add_column(column_name, column_type, options={})
      if Comable::Engine::config.respond_to?("#{type}_columns")
        return if Comable::Engine::config.send("#{type}_columns")[column_name]
      end
      @migration.add_column table_name, column_name, column_type, options
    end
  end
end
