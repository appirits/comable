class CreateDummyProduct < ActiveRecord::Migration
  def change
    create_table :dummy_products do |t|
      t.string :title, nil: false
      t.string :code, null: false
      t.integer :price, null: false
      t.text :caption
      t.string :sku_h_item_name
      t.string :sku_v_item_name
      t.timestamps
    end
  end
end
