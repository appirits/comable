class CreateComableCartItems < ActiveRecord::Migration
  def change
    create_table :comable_cart_items do |t|
      t.integer Comable::Customer.name.foreign_key, null: false
      t.integer Comable::Stock.name.foreign_key, null: false
      t.integer :quantity, default: 1, null: false
    end

    add_index :comable_cart_items, [Comable::Customer.name.foreign_key, Comable::Stock.name.foreign_key], unique: true
  end
end
