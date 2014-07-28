class CreateComableOrderDeliveries < Comable::Migration
  def change
    create_table :comable_order_deliveries do |t|
      t.integer :comable_order_id, null: false
      t.string :family_name, null: false
      t.string :first_name, null: false
    end
  end
end
