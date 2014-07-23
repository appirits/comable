class AddColumnsToOrderDeliveries < ActiveRecord::Migration
  def change
    add_column_safety_to_order_deliveries Comable::Order.name.foreign_key, :integer, null: false
    add_column_safety_to_order_deliveries :family_name, :string, null: false
    add_column_safety_to_order_deliveries :first_name, :string, null: false
  end

  private

  def add_column_safety_to_order_deliveries(column_name, type_name, options = {})
    return if Utusemi.config.map(:order_delivery).attributes[column_name]
    add_column Comable::OrderDelivery.table_name, column_name, type_name, options
  end
end
