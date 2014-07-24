class AddColumnsToOrders < ActiveRecord::Migration
  def change
    add_column_safety_to_orders Comable::Customer.name.foreign_key, :integer
    add_column_safety_to_orders :code, :string, null: false
    add_column_safety_to_orders :family_name, :string, null: false
    add_column_safety_to_orders :first_name, :string, null: false
    add_column_safety_to_orders :ordered_at, :datetime, null: false
  end

  private

  def add_column_safety_to_orders(column_name, type_name, options = {})
    return if Utusemi.config.map(:order).attributes[column_name]
    add_column Comable::Order.table_name, column_name, type_name, options
  end
end
