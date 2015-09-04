class CreateComableOptionValues < ActiveRecord::Migration
  def change
    create_table :comable_option_values, id: false do |t|
      t.string :option_type_name, null: false
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :comable_option_values, [:option_type_name, :name], unique: true
  end
end
