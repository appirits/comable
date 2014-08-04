class CreateComableCartItems < ActiveRecord::Migration
  def change
    create_table :comable_cart_items do |t|
      t.integer :comable_customer_id
      t.integer :comable_stock_id, null: false
      t.integer :quantity, default: 1, null: false
      t.string :guest_token
    end

    add_index :comable_cart_items, [:comable_customer_id, :comable_stock_id], unique: true, name: :comable_cart_items_idx_01
  end
end
