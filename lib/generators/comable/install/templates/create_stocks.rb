class CreateStocks < ActiveRecord::Migration
  def change
    create_table :<%= Comable::Stock.table_name %>
  end
end
