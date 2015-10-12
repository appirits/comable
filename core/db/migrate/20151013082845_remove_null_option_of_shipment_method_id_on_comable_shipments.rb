class RemoveNullOptionOfShipmentMethodIdOnComableShipments < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :comable_shipments do |t|
        dir.up   { t.change :shipment_method_id, :integer, null: true }
        dir.down { t.change :shipment_method_id, :integer, null: false }
      end
    end
  end
end
