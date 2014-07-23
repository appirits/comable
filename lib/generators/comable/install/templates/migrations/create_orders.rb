class CreateOrders < ActiveRecord::Migration
  def change
    create_table :<%= Comable::Order.table_name %>
  end
end
