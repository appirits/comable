class AddColumnsToOrderDeliveries < Comable::Migration
  def change
    add_column_safety_to_order_deliveries Comable::Order.name.foreign_key, :integer, null: false
    add_column_safety_to_order_deliveries :family_name, :string, null: false
    add_column_safety_to_order_deliveries :first_name, :string, null: false
  end
end
