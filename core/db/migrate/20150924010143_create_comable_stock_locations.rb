class CreateComableStockLocations < ActiveRecord::Migration
  def change
    create_table :comable_stock_locations do |t|
      t.string :name, null: false
      t.boolean :default, null: false, default: false
      t.boolean :active, null: false, default: true
      t.references :address
      t.timestamps null: false
    end
  end
end
