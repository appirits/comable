class AddColumnsToStocks < Comable::Migration
  def change
    add_column_safety_to_stocks Comable::Product.name.foreign_key, :integer
    add_column_safety_to_stocks :product_id_num, :integer
    add_column_safety_to_stocks :code, :string, null: false
    add_column_safety_to_stocks :quantity, :integer
    add_column_safety_to_stocks :sku_h_choice_name, :string
    add_column_safety_to_stocks :sku_v_choice_name, :string
  end
end
