class CreateComableCartItems < ActiveRecord::Migration
  def change
    create_table :comable_cart_items do |t|
      t.references customer_table_name, null: false
      t.references product_table_name, null: false
      t.integer :quantity, default: 1, null: false
    end

    add_index :comable_cart_items, [ "#{customer_table_name}_id", "#{product_table_name}_id" ], unique: true, name: 'comable_cart_items_by_customer'
  end

  private

  # TODO: リファクタリング
  def customer_table_name
    if Comable::Engine::config.respond_to?(:customer_table)
      Comable::Engine::config.customer_table.to_s.singularize
    else
      :comable_customer
    end
  end

  def product_table_name
    if Comable::Engine::config.respond_to?(:product_table)
      Comable::Engine::config.product_table.to_s.singularize
    else
      :comable_product
    end
  end
end
