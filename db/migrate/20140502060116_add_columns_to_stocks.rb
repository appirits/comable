class AddColumnsToStocks < ActiveRecord::Migration
  def change
    add_column_safety_to_stocks :"#{products_table_name}_id", :integer
    add_column_safety_to_stocks :product_id_num, :integer
    add_column_safety_to_stocks :code, :string, null: false
    add_column_safety_to_stocks :quantity, :integer
    add_column_safety_to_stocks :sku_h_choice_name, :string
    add_column_safety_to_stocks :sku_v_choice_name, :string
  end

  private

  def products_table_name
    return :product unless Comable::Engine.config.respond_to?(:product_table)
    Comable::Engine.config.product_table.to_s.singularize.to_sym
  end

  def add_column_safety_to_stocks(column_name, type_name, options = {})
    return if Utusemi.config.map(:stock).attributes[column_name]
    add_column Comable::Engine.config.stock_table, column_name, type_name, options
  end
end
