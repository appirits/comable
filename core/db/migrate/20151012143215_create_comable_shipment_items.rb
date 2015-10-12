class CreateComableShipmentItems < ActiveRecord::Migration
  def change
    create_table :comable_shipment_items do |t|
      t.references :shipment, null: false
      t.references :stock, null: false
      t.timestamps null: false
    end

    add_index :comable_shipment_items, :shipment_id
  end
end
