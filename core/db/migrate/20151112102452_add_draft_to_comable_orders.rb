class AddDraftToComableOrders < ActiveRecord::Migration
  def change
    change_table :comable_orders do |t|
      t.boolean :draft, null: false, default: false
    end
  end
end
