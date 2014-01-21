# This migration comes from comable (originally 20140120024159)
class CreateComableCartItems < ActiveRecord::Migration
  def change
    create_table :comable_cart_items do |t|
      t.references customer_table_name, null: false
      t.references product_table_name, null: false
      t.integer :quantity, default: 1, null: false
    end

    add_index :comable_cart_items, [ "#{customer_table_name}_id", "#{product_table_name}_id" ], unique: true
  end

  private

  def customer_table_name
    Comable::Engine::config.customer_table.to_s.singularize
  end

  def product_table_name
    Comable::Engine::config.product_table.to_s.singularize
  end
end
