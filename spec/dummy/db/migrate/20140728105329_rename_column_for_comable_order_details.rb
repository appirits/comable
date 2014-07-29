class RenameColumnForComableOrderDetails < ActiveRecord::Migration
  def change
    change_table :comable_order_details do |t|
      t.rename :comable_stock_id, :stock_id
    end
  end
end
