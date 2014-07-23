class AddColumnsToStocks < ActiveRecord::Migration
  def change
    add_column_safety_to_stocks Comable::Product.name.foreign_key, :integer
    add_column_safety_to_stocks :product_id_num, :integer
    add_column_safety_to_stocks :code, :string, null: false
    add_column_safety_to_stocks :quantity, :integer
    add_column_safety_to_stocks :sku_h_choice_name, :string
    add_column_safety_to_stocks :sku_v_choice_name, :string
  end

  private

  def add_column_safety_to_stocks(column_name, type_name, options = {})
    return if Utusemi.config.map(:stock).attributes[column_name]
    add_column Comable::Stock.table_name, column_name, type_name, options
  end
end
