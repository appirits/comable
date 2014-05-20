class CreateComableOrderDetails < ActiveRecord::Migration
  def change
    create_table :comable_order_details do |t|
      t.references :comable_order_delivery, null: false
      t.references stock_table_name, null: false
      t.integer :price, null: false
      t.integer :quantity, default: 1, null: false
      t.timestamps
    end
  end

  private

  def stock_table_name
    Comable::Engine.config.stock_table.to_s.singularize
  end
end
