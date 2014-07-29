class CreateComableOrders < Comable::Migration
  def change
    create_table :comable_orders do |t|
      t.integer :comable_customer_id
      t.string :code, null: false
      t.string :family_name, null: false
      t.string :first_name, null: false
      t.datetime :ordered_at, null: false
    end

    add_index :comable_orders, :code, unique: true, name: :comable_orders_idx_01
  end
end
