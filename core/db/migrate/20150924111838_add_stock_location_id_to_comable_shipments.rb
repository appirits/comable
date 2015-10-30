class AddStockLocationIdToComableShipments < ActiveRecord::Migration
  def change
    change_table :comable_shipments do |t|
      t.references :stock_location
    end
  end
end
