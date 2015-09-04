class CreateComableOptionTypes < ActiveRecord::Migration
  def change
    create_table :comable_option_types, id: false do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :comable_option_types, :name, unique: true
  end
end
