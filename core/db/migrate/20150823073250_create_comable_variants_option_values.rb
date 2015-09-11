class CreateComableVariantsOptionValues < ActiveRecord::Migration
  def change
    create_table :comable_variants_option_values do |t|
      t.references :variant, null: false, index: true
      t.references :option_value, null: false, index: true
    end
  end
end
