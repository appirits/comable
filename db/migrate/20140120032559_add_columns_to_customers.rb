class AddColumnsToCustomers < ActiveRecord::Migration
  def change
    add_column_safety_to_customers :family_name, :string, null: false
    add_column_safety_to_customers :first_name, :string, null: false
  end

  private

  def add_column_safety_to_customers(column_name, type_name, options = {})
    return if Utusemi.config.map(:customer).attributes[column_name]
    add_column Comable::Customer.table_name, column_name, type_name, options
  end
end
