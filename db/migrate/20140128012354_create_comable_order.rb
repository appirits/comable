class CreateComableOrder < ActiveRecord::Migration
  def change
    create_table :comable_orders do |t|
      t.integer Comable::Customer.name.foreign_key
      t.string :code, null: false
      t.string :family_name, null: false
      t.string :first_name, null: false
      t.timestamps
    end
  end
end
