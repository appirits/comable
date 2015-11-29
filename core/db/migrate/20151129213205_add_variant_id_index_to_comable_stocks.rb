class AddVariantIdIndexToComableStocks < ActiveRecord::Migration
  def change
    add_index :comable_stocks, :variant_id
  end
end
