class CreateComableVariantsOptionValues < ActiveRecord::Migration
  def change
    create_table :comable_variants_option_values do |t|
      t.references :variant, null: false, index: true
      t.string :option_value_name, null: false, index: true
    end
  end
end
