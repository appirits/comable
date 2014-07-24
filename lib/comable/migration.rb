module Comable
  class Migration < ActiveRecord::Migration
    def self.define_add_column_safety_method_for(type)
      define_method "add_column_safety_to_#{type.to_s.pluralize}" do |column_name, type_name, options = {}|
        column_name_sym = column_name.to_sym
        return if Utusemi.config.map(type).attributes[column_name_sym]
        add_column Comable.const_get(type.to_s.classify).table_name, column_name_sym, type_name, options
      end
    end

    COMABLE_TYPES = %w( product stock customer order order_delivery order_detail )
    COMABLE_TYPES.each do |type|
      define_add_column_safety_method_for(type)
    end
  end
end
