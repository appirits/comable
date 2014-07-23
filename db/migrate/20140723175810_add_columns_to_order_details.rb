class AddColumnsToOrderDetails < ActiveRecord::Migration
  def change
    add_column_safety_to_order_details Comable::OrderDelivery.name.foreign_key, :integer, null: false
    add_column_safety_to_order_details Comable::Stock.name.foreign_key, :integer, null: false
    add_column_safety_to_order_details :price, :integer, null: false
    add_column_safety_to_order_details :quantity, :integer, default: 1, null: false
  end

  private

  def add_column_safety_to_order_details(column_name, type_name, options = {})
    return if Utusemi.config.map(:order_detail).attributes[column_name]
    add_column Comable::OrderDetail.table_name, column_name, type_name, options
  end
end
