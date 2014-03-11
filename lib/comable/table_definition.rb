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

    def missing_method(method_name, *args)
      if Comable::Engine::config.respond_to?("#{type}_columns")
        column_name = args.first
        return if Comable::Engine::config.send("#{type}_columns")[column_name]
      end
      @migration.add_column table_name, *args
    end
  end
end
