class CreateComableOrders < ActiveRecord::Migration
  def change
    create_table :comable_orders do |t|
      t.integer :comable_customer_id
      t.integer :comable_payment_id
      t.string :guest_token
      t.string :code
      t.string :email
      t.integer :shipment_fee, null: false, default: 0
      t.string :shipment_tracking_number
      t.integer :shipment_method_id
      t.integer :total_price
      t.references :bill_address
      t.references :ship_address
      t.string :state
      t.datetime :completed_at
    end

    add_index :comable_orders, :code, unique: true, name: :comable_orders_idx_01
  end
end
