class CreateComableOrderDetails < ActiveRecord::Migration
  def change
    create_table :comable_order_details do |t|
      t.references :comable_order_delivery, null: false
      t.references product_table_name, null: false
      t.integer :price, null: false
      t.integer :quantity, default: 1, null: false
      t.timestamps
    end
  end

  private

  def product_table_name
    Comable::Engine::config.product_table.to_s.singularize
  end
end
