class CreateComableShipmentMethods < ActiveRecord::Migration
  def change
    create_table :comable_shipment_methods do |t|
      t.boolean :activate_flag, null: false, default: true
      t.string :name, null: false
      t.integer :fee, null: false
      t.string :traking_url
      t.timestamps null: false
    end
  end
end
