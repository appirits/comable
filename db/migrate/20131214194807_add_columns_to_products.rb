class AddColumnsToProducts < ActiveRecord::Migration
  def change
    add_column_safety_to_products :name, :string, null: false
    add_column_safety_to_products :code, :string, null: false
    add_column_safety_to_products :price, :integer
    add_column_safety_to_products :caption, :text
    add_column_safety_to_products :sku_h_item_name, :string
    add_column_safety_to_products :sku_v_item_name, :string
  end

  private

  def add_column_safety_to_products(column_name, type_name, options = {})
    return if Utusemi.config.map(:product).attributes[column_name]
    add_column Comable::Product.table_name, column_name, type_name, options
  end
end
