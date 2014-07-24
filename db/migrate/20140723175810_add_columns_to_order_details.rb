class AddColumnsToOrderDetails < Comable::Migration
  def change
    add_column_safety_to_order_details Comable::OrderDelivery.name.foreign_key, :integer, null: false
    add_column_safety_to_order_details Comable::Stock.name.foreign_key, :integer, null: false
    add_column_safety_to_order_details :price, :integer, null: false
    add_column_safety_to_order_details :quantity, :integer, default: 1, null: false
  end
end
