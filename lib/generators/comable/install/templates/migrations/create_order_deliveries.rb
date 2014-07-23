class CreateOrderDeliveries < ActiveRecord::Migration
  def change
    create_table :<%= Comable::OrderDelivery.table_name %>
  end
end
