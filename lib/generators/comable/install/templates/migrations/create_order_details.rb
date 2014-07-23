class CreateOrderDetails < ActiveRecord::Migration
  def change
    create_table :<%= Comable::OrderDetail.table_name %>
  end
end
