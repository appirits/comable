class CreateComableOrderDeliveries < Comable::Migration
  def change
    create_table :comable_order_deliveries do |t|
      t.integer :comable_order_id, null: false
      t.string :family_name
      t.string :first_name
    end
  end
end
