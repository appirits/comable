# This migration comes from comable (originally 20140120032559)
class AddColumnsToCustomers < ActiveRecord::Migration
  def change
    add_column_safety_to_customers :family_name, :string, null: false
    add_column_safety_to_customers :first_name, :string, null: false
  end

  private

  def add_column_safety_to_customers(column_name, type_name, options={})
    if Comable::Engine::config.respond_to?(:customer_columns)
      return if Comable::Engine::config.customer_columns[column_name]
    end
    add_column Comable::Engine::config.customer_table, column_name, type_name, options
  end
end
