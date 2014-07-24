class AddColumnsToProducts < Comable::Migration
  def change
    add_column_safety_to_products :name, :string, null: false
    add_column_safety_to_products :code, :string, null: false
    add_column_safety_to_products :price, :integer
    add_column_safety_to_products :caption, :text
    add_column_safety_to_products :sku_h_item_name, :string
    add_column_safety_to_products :sku_v_item_name, :string
  end
end
