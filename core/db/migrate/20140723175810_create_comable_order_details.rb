class CreateComableOrderDetails < Comable::Migration
  def change
    create_table :comable_order_details do |t|
      t.integer :comable_order_delivery_id, null: false
      t.integer :comable_stock_id, null: false
      t.integer :price
      t.integer :quantity, default: 1, null: false
    end

    add_index :comable_order_details, [:comable_order_delivery_id, :comable_stock_id], unique: true, name: :comable_order_details_idx_01
  end
end
