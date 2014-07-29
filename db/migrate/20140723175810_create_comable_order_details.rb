class CreateComableOrderDetails < Comable::Migration
  def change
    create_table :comable_order_details do |t|
      t.integer :comable_order_delivery_id, null: false
      t.integer :comable_stock_id, null: false
      t.integer :price, null: false
      t.integer :quantity, default: 1, null: false
    end
  end
end
