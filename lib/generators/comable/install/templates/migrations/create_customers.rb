class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :<%= Comable::Customer.table_name %>
  end
end
