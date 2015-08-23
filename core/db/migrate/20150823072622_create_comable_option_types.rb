class CreateComableOptionTypes < ActiveRecord::Migration
  def change
    create_table :comable_option_types do |t|
      t.references :product, null: false
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :comable_option_types, [:product_id, :name], unique: true
  end
end
