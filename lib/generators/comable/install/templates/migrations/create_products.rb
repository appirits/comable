class CreateProducts < ActiveRecord::Migration
  def change
    create_table :<%= Comable::Product.table_name %>
  end
end
