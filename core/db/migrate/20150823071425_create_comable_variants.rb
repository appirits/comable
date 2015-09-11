class CreateComableVariants < ActiveRecord::Migration
  def change
    create_table :comable_variants do |t|
      t.references :product, null: false
      t.integer :price, null: false, default: 0
      t.string :sku
      t.timestamps null: false
    end
  end
end
