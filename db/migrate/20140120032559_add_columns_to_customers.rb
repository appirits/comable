class AddColumnsToCustomers < Comable::Migration
  def change
    add_column_safety_to_customers :family_name, :string, null: false
    add_column_safety_to_customers :first_name, :string, null: false
  end
end
