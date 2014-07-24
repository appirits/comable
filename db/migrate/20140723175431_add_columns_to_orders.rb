class AddColumnsToOrders < Comable::Migration
  def change
    add_column_safety_to_orders Comable::Customer.name.foreign_key, :integer
    add_column_safety_to_orders :code, :string, null: false
    add_column_safety_to_orders :family_name, :string, null: false
    add_column_safety_to_orders :first_name, :string, null: false
    add_column_safety_to_orders :ordered_at, :datetime, null: false
  end
end
