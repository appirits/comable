class RenameColumnForComableCartItems < ActiveRecord::Migration
  def change
    change_table :comable_cart_items do |t|
      t.rename :comable_stock_id, :stock_id
    end
  end
end
