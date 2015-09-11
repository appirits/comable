class CreateComableOptionValues < ActiveRecord::Migration
  def change
    create_table :comable_option_values do |t|
      t.references :option_type, null: false
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :comable_option_values, [:option_type_id, :name], unique: true
  end
end
