class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :dummy_product_id
      t.integer :units, nil: false

      t.integer :product_id_num
      t.string :code, null: false
      t.string :sku_h_choice_name
      t.string :sku_v_choice_name

      t.timestamps
    end
  end
end
