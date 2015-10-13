class AddGuestTokenIndexToComableOrders < ActiveRecord::Migration
  def change
    add_index :comable_orders, :guest_token
  end
end
