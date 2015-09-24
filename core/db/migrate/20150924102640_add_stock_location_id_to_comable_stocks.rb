class AddStockLocationIdToComableStocks < ActiveRecord::Migration
  def change
    change_table :comable_stocks do |t|
      t.references :stock_location
    end

    add_index :comable_stocks, :stock_location_id
    add_index :comable_stocks, [:stock_location_id, :variant_id]
  end
end
