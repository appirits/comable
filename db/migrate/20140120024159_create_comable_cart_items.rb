class CreateComableCartItems < ActiveRecord::Migration
  def change
    create_table :comable_cart_items do |t|
      t.references customer_table_name, null: false
      t.references stock_table_name, null: false
      t.integer :quantity, default: 1, null: false
    end

    add_index :comable_cart_items, ["#{customer_table_name}_id", "#{stock_table_name}_id"], unique: true
  end

  private

  def customer_table_name
    Comable::Engine.config.customer_table.to_s.singularize
  end

  def stock_table_name
    Comable::Engine.config.stock_table.to_s.singularize
  end
end
