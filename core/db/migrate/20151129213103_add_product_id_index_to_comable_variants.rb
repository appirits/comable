class AddProductIdIndexToComableVariants < ActiveRecord::Migration
  def change
    add_index :comable_variants, :product_id
  end
end
