# This migration comes from comable (originally 20140120024159)
class CreateComableCartItems < ActiveRecord::Migration
  def change
    create_table :comable_cart_items do |t|
      t.integer :customer_id, null: false
      t.integer :product_id, null: false
      t.integer :quantity, default: 1, null: false
    end

    add_index :comable_cart_items, [ :customer_id, :product_id ], unique: true
  end
end
